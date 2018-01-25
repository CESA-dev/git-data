import UIKit
import SwiftECP

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
        ECP(
            username: "YOUR_USERNAME",
            password: "YOUR_PASSWORD",
            protectedURL: URL(
                string: "https://app.university.edu"
            )!,
            logLevel: .debug
        ).login().start { event in
            switch event {

            case let .value(body):
                // If the request was successful, the protected resource will
                // be available in 'body'. Make sure to implement a mechanism to
                // detect authorization timeouts.
                print("Response body: \(body)")

                // The Shibboleth auth cookie is now stored in the sharedHTTPCookieStorage.
                // Attach this cookie to subsequent requests to protected resources.
                // You can access the cookie with the following code:
                if let cookies = HTTPCookieStorage.shared.cookies {
//                    let shibCookie = cookies.filter { (cookie: HTTPCookie) in
//                        cookie.name.rangeOfString("shibsession") != nil
//                        }[0]
//                    print(shibCookie)
                    print(cookies)
                }

            case let .failed(error):
                // This is an NSError containing both a user-friendly message and a
                // technical debug message. This can help diagnose problems with your
                // SP, your IdP, or even this library :)

                // User-friendly error message
                print(error.localizedDescription)

                // Technical/debug error message
                print(error.localizedFailureReason)

            default:
                break
            }
        }
    }
}
