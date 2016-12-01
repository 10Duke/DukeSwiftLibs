import Foundation
import UIKit


/**
 * Protocol for defining public SSO functionality.
 */
protocol SSO {

    func isUserLoggedIn() -> Bool

    func login(controller: UINavigationController)

    func login(baseUrl: String, clientId: String, controller: UINavigationController)

    func logout(controller: UINavigationController)

    func logout(baseUrl: String, clientId: String, controller: UINavigationController)

}
