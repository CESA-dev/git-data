import Foundation
import Alamofire
import AEXML
//import ReactiveCocoa
import ReactiveSwift
import XCGLogger

public struct ECP {
	public let username: String
	public let password: String
	var basicAuth: String? {
		get {
        
            let string = "\(username):\(password)"
            return string.data(using: .ascii)?.base64EncodedString()
		}
	}
	public let protectedURL: URL
	
	let log = XCGLogger.default
	
	public init(
        username: String,
        password: String,
        protectedURL: URL,
        logLevel: XCGLogger.Level
    ) {
		self.username = username
		self.password = password
		self.protectedURL = protectedURL
        
        log.setup(level: logLevel,
                  showLogIdentifier: true,
                  showFunctionName: true,
                  showThreadName: false,
                  showLevel: true,
                  showFileNames: true,
                  showLineNumbers: true,
                  showDate: true,
                  writeToFile: nil,
                  fileLevel: nil)
    
	}
	
	struct IdpRequestData {
		let request: URLRequest
		let responseConsumerURL: URL
		let relayState: AEXMLElement?
	}

    public func login() -> SignalProducer<String, NSError> {
        let req = Alamofire.request(self.buildInitialRequest())
        return req.responseXML()
        .flatMap(.concat) { self.sendIdpRequest(initialSpResponse: $0.value) }
        .flatMap(.concat) { self.sendSpRequest(document: $0.0.value, idpRequestData: $0.1) }
    }

    func sendIdpRequest(
        initialSpResponse: AEXMLDocument
    ) -> SignalProducer<(CheckedResponse<AEXMLDocument>, IdpRequestData), NSError> {
        return SignalProducer { observer, disposable in
            do {
                let idpRequestData = try self.buildIdpRequest(body: initialSpResponse)
                let req = Alamofire.request(idpRequestData.request)
                req.responseString().map { ($0, idpRequestData) }.start { event in
                    switch event {
                    case .value(let value):

                        let stringResponse = value.0

                        guard case 200 ... 299 = stringResponse.response.statusCode else {
                            self.log.debug("Received \(stringResponse.response.statusCode) response from IdP")
                            observer.send(error: ECPError.IdpRequestFailed.error)
                            break
                        }

                        guard let responseData = stringResponse.value.data(using: String.Encoding.utf8) else {
                            observer.send(error: ECPError.XMLSerialization.error)
                            break
                        }

                        guard let responseXML = try? AEXMLDocument(xml: responseData) else {
                            observer.send(error: ECPError.XMLSerialization.error)
                            break
                        }

                        let xmlResponse = CheckedResponse<AEXMLDocument>(
                            request: stringResponse.request,
                            response: stringResponse.response,
                            value: responseXML
                        )

                        observer.send(value: (xmlResponse, value.1))
                        observer.sendCompleted()

                    case .failed(let error):
                        observer.send(error: error)
                    default:
                        break
                    }
                }
            } catch {
                observer.send(error: error as NSError)
            }
        }
    }

    func sendSpRequest(
        document: AEXMLDocument,
        idpRequestData: IdpRequestData
    ) -> SignalProducer<String, NSError> {
        return SignalProducer { observer, disposable in
            do {
                let request = try self.buildSpRequest(
                    body: document,
                    idpRequestData: idpRequestData
                )

                let req = Alamofire.request(request)
                req.responseString(errorOnNil: false).map { $0.value }.start { event in
                    switch event {
                    case .value(let value):
                        observer.send(value: value)
                        observer.sendCompleted()
                    case .failed(let error):
                        observer.send(error: error)
                    default:
                        break
                    }
                }
            } catch {
                observer.send(error: error as NSError)
            }
        }
    }

    func buildInitialRequest() -> URLRequest {
        // Create a request with the appropriate headers to trigger ECP on the SP.
        var request = URLRequest(url: self.protectedURL)
        request.setValue(
            "text/html; application/vnd.paos+xml",
            forHTTPHeaderField: "Accept"
        )
        request.setValue(
            "ver=\"urn:liberty:paos:2003-08\";\"urn:oasis:names:tc:SAML:2.0:profiles:SSO:ecp\"",
            forHTTPHeaderField: "PAOS"
        )
        request.timeoutInterval = 10
        log.debug("Built initial SP request.")
        return request
    }

    func buildIdpRequest(body: AEXMLDocument) throws -> IdpRequestData {
        log.debug("Initial SP SOAP response:")
        log.debug(body.xml)

        // Remove the XML signature
        body.root["S:Body"]["samlp:AuthnRequest"]["ds:Signature"].removeFromParent()
        log.debug("Removed the XML signature from the SP SOAP response.")
        
        // Store this so we can compare it against the AssertionConsumerServiceURL from the IdP
        let responseConsumerURLString = body.root["S:Header"]["paos:Request"]
            .attributes["responseConsumerURL"]

        guard let rcuString = responseConsumerURLString,
              let responseConsumerURL = URL(string: rcuString)
        else {
            throw ECPError.ResponseConsumerURL
        }

        log.debug("Found the ResponseConsumerURL in the SP SOAP response.")
        
        // Get the SP request's RelayState for later
        // This may or may not exist depending on the SP/IDP
        let relayState = body.root["S:Header"]["ecp:RelayState"].first
        
        if relayState != nil {
            log.debug("SP SOAP response contains RelayState.")
        } else {
            log.warning("No RelayState present in the SP SOAP response.")
        }
        
        // Get the IdP's URL
        let idpURLString = body.root["S:Body"]["samlp:AuthnRequest"]["samlp:Scoping"]["samlp:IDPList"]["samlp:IDPEntry"]
            .attributes["ProviderID"]

        guard let idp = idpURLString,
            let idpURL = URL(string: idp),
            let idpHost = idpURL.host,
            let idpEcpURL = URL(string: "https://\(idpHost)/idp/profile/SAML2/SOAP/ECP")
        else {
            throw ECPError.IdpExtraction
        }

        log.debug("Found IdP URL in the SP SOAP response.")
        // Make a new SOAP envelope with the SP's SOAP body only
        let body = body.root["S:Body"]
        let soapDocument = AEXMLDocument()
        let soapAttributes = [
            "xmlns:S": "http://schemas.xmlsoap.org/soap/envelope/"
        ]
        let envelope = soapDocument.addChild(
            name: "S:Envelope",
            attributes: soapAttributes
        )
        envelope.addChild(body)

        guard let soapString = envelope.xml.data(using: String.Encoding.utf8) else {
            throw ECPError.SoapGeneration
        }

        guard let basicAuth = self.basicAuth else {
            throw ECPError.MissingBasicAuth
        }

        log.debug("Sending this SOAP to the IDP:")
        log.debug(envelope.xml)

        var idpReq = URLRequest(url: idpEcpURL)
        idpReq.httpMethod = "POST"
        idpReq.httpBody = soapString
        idpReq.setValue(
            "application/vnd.paos+xml",
            forHTTPHeaderField: "Content-Type"
        )
        idpReq.setValue(
            "Basic " + basicAuth,
            forHTTPHeaderField: "Authorization"
        )
        idpReq.timeoutInterval = 10
        log.debug("Built first IdP request.")
        
        return IdpRequestData(
            request: idpReq,
            responseConsumerURL: responseConsumerURL,
            relayState: relayState
        )
	}
	
    func buildSpRequest(body: AEXMLDocument, idpRequestData: IdpRequestData) throws -> URLRequest {
        log.debug("IDP SOAP response:")
        log.debug(body.xml)

        guard let
            acuString = body.root["soap11:Header"]["ecp:Response"]
                .attributes["AssertionConsumerServiceURL"],
            let assertionConsumerServiceURL = URL(string: acuString)
        else {
            throw ECPError.AssertionConsumerServiceURL
        }

        log.debug("Found AssertionConsumerServiceURL in IdP SOAP response.")
        
        // Make a new SOAP envelope with the following:
        //     - (optional) A SOAP Header containing the RelayState from the first SP response
        //     - The SOAP body of the IDP response
        let spSoapDocument = AEXMLDocument()
        
        // XML namespaces are just...lovely
        let spSoapAttributes = [
            "xmlns:S": "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:soap11": "http://schemas.xmlsoap.org/soap/envelope/"
        ]
        let envelope = spSoapDocument.addChild(
            name: "S:Envelope",
            attributes: spSoapAttributes
        )

        // Bail out if these don't match
        
        guard idpRequestData.responseConsumerURL.absoluteString == assertionConsumerServiceURL.absoluteString else {
                if let request = buildSoapFaultRequest(
                    URL: idpRequestData.responseConsumerURL,
                    error: ECPError.Security.error
                    ) {
                        sendSpSoapFaultRequest(request: request)
                }
                throw ECPError.Security
        }

        if let relay = idpRequestData.relayState {
            let header = envelope.addChild(name: "S:Header")
            header.addChild(relay)
            log.debug("Added RelayState to the SOAP header for the final SP request.")
        }
        
        let extractedBody = body.root["soap11:Body"]
        envelope.addChild(extractedBody)

        guard let bodyData = envelope.xml.data(using: String.Encoding.utf8) else {
            throw ECPError.SoapGeneration
        }

        log.debug("Sending this SOAP to the SP:")
        log.debug(envelope.xml)

        var spReq = URLRequest(url: assertionConsumerServiceURL)
        spReq.httpMethod = "POST"
        spReq.httpBody = bodyData
        spReq.setValue(
            "application/vnd.paos+xml",
            forHTTPHeaderField: "Content-Type"
        )
        spReq.timeoutInterval = 10

        log.debug("Built final SP request.")
        return spReq
	}
	
	// Something the spec wants but we don't need. Fire and forget.
	func sendSpSoapFaultRequest(request: URLRequest) {
		let request = Alamofire.request(request)
        request.responseString { response in
            if let value = response.result.value {
                self.log.debug(value)
            } else if let error = response.result.error {
                self.log.warning(error.localizedDescription)
            }
        }
	}

	func buildSoapFaultBody(error: NSError) -> Data? {
		let soapDocument = AEXMLDocument()
		let soapAttribute = [
			"xmlns:SOAP-ENV": "http://schemas.xmlsoap.org/soap/envelope/"
		]
		let envelope = soapDocument.addChild(
			name: "SOAP-ENV:Envelope",
			attributes: soapAttribute
		)
		let body = envelope.addChild(name: "SOAP-ENV:Body")
		let fault = body.addChild(name: "SOAP-ENV:Fault")
		fault.addChild(name: "faultcode", value: String(error.code))
		fault.addChild(name: "faultstring", value: error.localizedDescription)
		return soapDocument.xml.data(using: String.Encoding.utf8)
	}
	
	func buildSoapFaultRequest(URL: URL, error: NSError) -> URLRequest? {
		if let body = buildSoapFaultBody(error: error) {
			var request = URLRequest(url: URL)
			request.httpMethod = "POST"
            request.httpBody = body
			request.setValue(
				"application/vnd.paos+xml",
				forHTTPHeaderField: "Content-Type"
			)
			request.timeoutInterval = 10

			return request
		}
		return nil
	}
	
	enum ECPError: Error {
		case Extraction
		case EmptyBody
		case SoapGeneration
		case IdpExtraction
		case RelayState
		case ResponseConsumerURL
		case AssertionConsumerServiceURL
		case Security
		case MissingBasicAuth
		case WTF
        case IdpRequestFailed
        case XMLSerialization
		
		private var domain: String {
			return "edu.clemson.swiftecp"
		}
		
		private var errorCode: Int {
			switch self {
			case .Extraction:
				return 200
			case .EmptyBody:
				return 201
			case .SoapGeneration:
				return 202
			case .IdpExtraction:
				return 203
			case .RelayState:
				return 204
			case .ResponseConsumerURL:
				return 205
			case .AssertionConsumerServiceURL:
				return 206
			case .Security:
				return 207
			case .MissingBasicAuth:
				return 208
			case .WTF:
				return 209
            case .IdpRequestFailed:
                return 210
            case .XMLSerialization:
                return 211
			}
		}
		
		var userMessage: String {
			switch self {
			case .EmptyBody:
				return "The password you entered is incorrect. Please try again."
            case .IdpRequestFailed:
                return "The password you entered is incorrect. Please try again."
			default:
				return "An unknown error occurred. Please let us know how you arrived at this error and we will fix the problem as soon as possible."
			}
		}
		
		var description: String {
			switch self {
			case .Extraction:
				return "Could not extract the necessary info from the XML response."
			case .EmptyBody:
				return "Empty body. The given password is likely incorrect."
			case .SoapGeneration:
				return "Could not generate a valid SOAP request body from the response's SOAP body."
			case .IdpExtraction:
				return "Could not extract the IDP endpoint from the SOAP body."
			case .RelayState:
				return "Could not extract the RelayState from the SOAP body."
			case .ResponseConsumerURL:
				return "Could not extract the ResponseConsumerURL from the SOAP body."
			case .AssertionConsumerServiceURL:
				return "Could not extract the AssertionConsumerServiceURL from the SOAP body."
			case .Security:
				return "ResponseConsumerURL did not match AssertionConsumerServiceURL."
			case .MissingBasicAuth:
				return "Could not generate basic auth from the given username and password."
			case .WTF:
				return "Unknown error. Please contact the library developer."
            case .IdpRequestFailed:
                return "IdP request failed. The given password is likely incorrect."
            case .XMLSerialization:
                return "Unable to serialize response to XML."
			}
		}
		
		var error: NSError {
			return NSError(domain: domain, code: errorCode, userInfo: [
				NSLocalizedDescriptionKey: userMessage,
				NSLocalizedFailureReasonErrorKey: description
			])
		}
	}
}
