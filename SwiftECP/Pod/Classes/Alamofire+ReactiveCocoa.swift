import Foundation
import AEXML
import Alamofire
//import ReactiveCocoa
import ReactiveSwift

public struct CheckedResponse<T> {
    let request: URLRequest
    let response: HTTPURLResponse
    let value: T
}

public enum SerializationError: Int {
    case DataSerializationFailed           = -6000
       
}


extension Alamofire.DataRequest {
    
    public static func xmlResponseSerializer() -> DataResponseSerializer<AEXMLDocument> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else { return .failure(error!) }

            guard let validData = data, validData.count > 0 else {
                let failureReason = "Could not serialize data. Input data was nil or zero length."
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: "com.MyAppName.error", code: SerializationError.DataSerializationFailed.rawValue, userInfo: userInfo)

                return .failure(error)
            }

            do {
                let document = try AEXMLDocument(xml: validData)
                return .success(document)
            } catch {
                return .failure(error as NSError)
            }
        }
    }

    public static func emptyAllowedStringResponseSerializer() -> DataResponseSerializer<String> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else { return .failure(error!) }

            guard let
                validData = data,
                let string = String(data: validData, encoding: String.Encoding.utf8)
            else {
                return .success("")
            }

            return .success(string)
        }
    }
    
    @discardableResult
    public func responseXML(completionHandler: @escaping (DataResponse<AEXMLDocument>) -> Void) -> Self {
        return response(queue: nil, responseSerializer: DataRequest.xmlResponseSerializer() , completionHandler: completionHandler)
    }

    @discardableResult
    public func responseStringEmptyAllowed(completionHandler: @escaping (DataResponse<String>) -> Void) -> Self {
        return response(queue: nil, responseSerializer: DataRequest.emptyAllowedStringResponseSerializer(), completionHandler: completionHandler)
    }

    public func responseXML() -> SignalProducer<CheckedResponse<AEXMLDocument>, NSError> {
        return SignalProducer { observer, disposable in
            self.responseXML { response in
                if let error = response.result.error {
                    return observer.send(error: error as NSError)
                }

                guard let document = response.result.value else {
                    return observer.send(error: AlamofireRACError.XMLSerialization as NSError)
                }

                guard let request = response.request, let response = response.response else {
                    return observer.send(error: AlamofireRACError.IncompleteResponse as NSError)
                }

                observer.send(
                    value: CheckedResponse<AEXMLDocument>(
                        request: request, response: response, value: document
                    )
                )
                observer.sendCompleted()
            }
        }
    }

    public func responseString(errorOnNil: Bool = true) -> SignalProducer<CheckedResponse<String>, NSError> {
        return SignalProducer { observer, disposable in
            self.responseStringEmptyAllowed { response in
                if let error = response.result.error {
                    return observer.send(error: error as NSError)
                }

                if errorOnNil && response.result.value?.characters.count == 0 {
                    return observer.send(error:AlamofireRACError.IncompleteResponse as NSError)
                }

                guard let req = response.request, let resp = response.response else {
                    return observer.send(error:AlamofireRACError.IncompleteResponse as NSError)
                }

                observer.send(
                    value: CheckedResponse<String>(
                        request: req, response: resp, value: response.result.value ?? ""
                    )
                )
                observer.sendCompleted()
            }
        }
    }
}

enum AlamofireRACError: Error {
    case XMLSerialization
    case IncompleteResponse
}
