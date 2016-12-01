import UIKit
import WebKit


/**
 * View controller responsible for showing web pages during SSO login and logout.
 */
class WKWebViewController: UIViewController, WKNavigationDelegate {

    /**
     * The webview for rendering web content.
     */
    var m_webView: WKWebView!

    /**
     * OAuth2 bearer token in case it exists.
     */
    var m_token: String?

    /**
     * The request URL.
     */
    var m_requestUrl: URL?


    /**
     * Setter for OAuth2 Bearer token.
     */
    public func setToken(_ token: String) {
        //
        m_token = token
    }


    /**
     * Setter for request URL.
     */
    public func setRequestUrl(_ requestUrl: URL) {
        //
        m_requestUrl = requestUrl
    }


    /**
     * Generic delegate method called when view is loaded.
     *
     * Opens up WKWebView with given URL and sets up the Authorization
     * header containing the Bearer token in case it's available.
     */
    override public func viewDidLoad() {
        //
        super.viewDidLoad()
        //
        var request = URLRequest(url: m_requestUrl!)
        if m_token != nil {
            request.setValue("Bearer \(m_token)", forHTTPHeaderField: "Authorization")
        }
        m_webView.load(request)
    }

    /**
     * Generic delegate method called when loading the view.
     *
     * Setup for the WKWebView container for displaying web content.
     */
    override func loadView() {
        //
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.processPool = SSOImpl.shared.getProcessPool()
        m_webView = WKWebView(frame: .zero, configuration: webConfiguration)
        m_webView.navigationDelegate = self
        self.view = m_webView
    }


    override func didReceiveMemoryWarning() {
        //
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /**
     * Delegate function for intercepting navigation actions.
     *
     * Detection for "Sign out" and "Continue" presses during logout.
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        //
        let apiConfig = ApiConfigImpl.shared
        let apiToken = ApiTokenImpl.shared
        //
        let baseUrl = "\(apiConfig.getIdPBaseUrl())"
        let authUrl = "\(baseUrl)\(apiConfig.getSsoOauth2ApiPath())"
        let loginUrl = "\(baseUrl)login"
        let logoutUrl = "\(baseUrl)\(apiConfig.getSsoLogoutPath())"
        //
        if let navigationUrl = navigationAction.request.url?.absoluteString {
            //
            print("navigationUrl: \(navigationUrl)")
            //
            // Sign out pressed...
            if navigationUrl == apiConfig.getSSORedirectUrl() {
                //
                if let navController = self.navigationController {
                    //
                    apiToken.resetToken()
                    navController.popViewController(animated: true)
                }
            // Continue pressed... (logout and login go through)
            } else if navigationUrl == baseUrl && !navigationUrl.hasPrefix(loginUrl) && !navigationUrl.hasPrefix(authUrl) && !navigationUrl.hasPrefix(logoutUrl) && navigationUrl.hasPrefix(apiConfig.getIdPBaseUrl()) {
                //
                if let navController = self.navigationController {
                    //
                    apiToken.resetToken()
                    navController.popViewController(animated: true)
                }
            }
        }
        //
        decisionHandler(.allow)
    }


    /**
     * Delegate function for intercepting navigation responses.
     *
     * Bounces the user back in the UI flow in case SSO redirect URL is detected.
     */
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        //
        if let navigationUrl = navigationResponse.response.url {
            //
            if navigationUrl.absoluteString == ApiConfigImpl.shared.getSSORedirectUrl() {
                //
                ApiTokenImpl.shared.resetToken()
                //
                if let navController = self.navigationController {
                    //
                    navController.popViewController(animated: true)
                }
            }
        }
        //
        decisionHandler(.allow)
    }


    /**
     * Delegate function for detecting redirects.
     *
     * Detection for successful login. In success case sets memory based OAuth2 bearer token.
     */
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        //
        let apiConfig = ApiConfigImpl.shared
        let apiToken = ApiTokenImpl.shared
        let authUtils = OAuth2ApiUtils.shared
        //
        let redirectUrl = "\(webView.url!)"
        //
        if redirectUrl.hasPrefix(apiConfig.getSSORedirectUrl()) {
            //
            var userId: String?
            var token: String?
            //
            if let idToken = authUtils.resolveParameterFromUrl(url: webView.url!, parameter: authUtils.ID_TOKEN) {
                //
                if let jwt = authUtils.decodeToken(idToken) {
                    //
                    userId = jwt.subject
                }
            }
            //
            if let authToken = authUtils.resolveParameterFromUrl(url: webView.url!, parameter: authUtils.ACCESS_TOKEN) {
                //
                token = authToken
            }
            //
            var storeSuccess = false
            //
            if (userId != nil && token != nil) {
                //
                storeSuccess = apiToken.storeToken(id: userId!, token: token!)
            }
            //
            if storeSuccess {
                //
                if let navController = self.navigationController {
                    //
                    navController.popViewController(animated: true)
                }
            } else {
                //
                apiToken.resetToken()
                //
                if let navController = self.navigationController {
                    //
                    navController.popViewController(animated: true)
                }
            }
        }
    }

}
