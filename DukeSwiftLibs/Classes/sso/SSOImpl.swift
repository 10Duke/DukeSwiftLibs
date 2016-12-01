import Foundation
import UIKit
import WebKit


/**
 * Class that holds SSO related external functionality.
 */
public class SSOImpl: SSO {

    public static let shared = SSOImpl()

    var m_processPool = WKProcessPool()


    /**
     * Process pool.
     *
     * - returns: Shared process pool that handles the web sessions.
     */
    public func getProcessPool()  -> WKProcessPool {
        //
        return m_processPool
    }


    /**
     * Login that uses ApiConfigImpl values for baseUrl and client id.
     *
     * - parameter controller: The UINavigationController that will push the Web view controller on screen.
     */
    public func login(controller: UINavigationController) {
        //
        login(baseUrl: ApiConfigImpl.shared.getIdPBaseUrl(), clientId: ApiConfigImpl.shared.getSSOClientId(), controller: controller)
    }


    /**
     * Login functionality.
     *
     * Opens up WKWebViewController with the login page.
     *
     * - parameter baseUrl: The baseUrl of the SSO service.
     * - parameter clientId: The string ID of the client.
     * - parameter controller: The UINavigationController that will push the Web view controller on screen.
     */
    public func login(baseUrl: String, clientId: String, controller: UINavigationController) {
        //
        if let loginUrl = OAuth2ApiUtils.shared.getLoginUrl() {
            //
            let storyboard = UIStoryboard(name: "10DukeWeb", bundle: getBundle())
            let webVC = storyboard.instantiateViewController(withIdentifier: "WKWebViewController") as! WKWebViewController
            webVC.setRequestUrl(loginUrl)
            controller.pushViewController(webVC, animated: true)
        }
    }


    /**
     * Logout that uses ApiConfigImpl values for baseUrl and client id.
     *
     * - parameter controller: The UINavigationController that will push the Web view controller on screen.
     */
    public func logout(controller: UINavigationController) {
        //
        logout(baseUrl: ApiConfigImpl.shared.getIdPBaseUrl(), clientId: ApiConfigImpl.shared.getSSOClientId(), controller: controller)
    }


    /**
     * Logout functionality.
     *
     * Opens up WKWebViewController with the logout page.
     *
     * - parameter baseUrl: The baseUrl of the SSO service.
     * - parameter clientId: The string ID of the client.
     * - parameter controller: The UINavigationController that will push the Web view controller on screen.
     */
    public func logout(baseUrl: String, clientId: String, controller: UINavigationController) {
        //
        if let logoutUrl = OAuth2ApiUtils.shared.getLogoutUrl() {
            //
            let storyboard = UIStoryboard(name: "10DukeWeb", bundle: getBundle())
            let webVC = storyboard.instantiateViewController(withIdentifier: "WKWebViewController") as! WKWebViewController
            webVC.setRequestUrl(logoutUrl)
            controller.pushViewController(webVC, animated: true)
        }
    }


    /**
     * Checks if user is logged in or not.
     *
     * - returns: True if user is logged in, false if not.
     */
    public func isUserLoggedIn() -> Bool {
        //
        if let token = ApiTokenImpl.shared.getToken() {
            if !token.isEmpty {
                return true
            }
        }
        //
        return false
    }


    /**
     * Resolves the DukeSwiftLibs Bundle.
     *
     * - returns: The DukeSwiftLibs bundle of resources.
     */
    func getBundle() -> Bundle? {
        //
        let bundlePath = Bundle(for: SSOImpl.self).path(forResource: "DukeSwiftLibs", ofType: "bundle")
        if let path = bundlePath {
            let bundle = Bundle(path: path)
            return bundle
        }
        //
        return nil
    }

}
