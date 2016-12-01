import Foundation


/**
 * Class that provides the client API configuration.
 */
class ClientConfig {

    /**
     * Singleton instance of the ApiConfig class.
     */
    public static let shared = ClientConfig()

    /**
     * Base API URL for IdP.
     */
    var m_apiUrl = "http://localhost:8080/"
    //var m_apiUrl = "http://vslidp.10duke.com/"

    /**
     * SSO Client ID.
     */
    var m_clientId = "ios_test"

    /**
     * SSO Redirect URL.
     */
    var m_ssoRedirectUrl = "tendukeauthapp://oauth/callback"


    /**
     * Getter for API URL client configuration
     *
     * - returns: IdP API url as a string.
     */
    func getApiUrl() -> String {
        //
        return m_apiUrl
    }


    /**
     * Getter for SSO client id.
     *
     * - returns: IdP SSO client id as a string.
     */
    func getSSOClientId() -> String {
        //
        return m_clientId
    }


    /**
     * Getter for SSO redirect URL configuration.
     *
     * - returns. IdP SSO client configured redirect url as a string.
     */
    func getSSORedirectUrl() -> String {
        //
        return m_ssoRedirectUrl
    }

}
