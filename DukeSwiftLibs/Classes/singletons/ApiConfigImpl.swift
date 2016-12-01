import Foundation


/**
 * Class that holds the API configuration.
 */
public final class ApiConfigImpl: ApiConfig {

    /**
     * Singleton instance of the ApiConfigImpl class.
     */
    public static let shared = ApiConfigImpl()


    /**
     * The IdP service base url as a string.
     */
    var m_idpBaseUrl: String = "http://localhost:8080/"

    /**
     * The SSO client id used for this API.
     */
    var m_ssoClientId: String = "ios_test"

    /**
     * The SSO redirect callback URL configured in the backend for this client.
     */
    var m_ssoRedirectUrl = "tendukeauthapp://oauth/callback"

    let SSO_OAUTH2_API_PATH = "oauth2/authz/"

    let SSO_LOGOUT_API_PATH = "logout"


    /**
     * Sets the client id.
     *
     * - parameter id: The SSO Client id to set for to the configuration.
     */
    public func setSSOClientId(_ id: String) {
        //
        m_ssoClientId = id
    }


    /**
     * Returns the client id.
     *
     * - returns: REST API SSO client id as string.
     */
    public func getSSOClientId() -> String {
        //
        return m_ssoClientId
    }


    /**
     * Sets the REST API BASE URL.
     *
     * - parameter baseUrl: The REST API base url string to set to configuration.
     */
    public func setIdPBaseUrl(_ baseUrl: String) {
        //
        m_idpBaseUrl = baseUrl
    }

    /**
     * Returns the REST API BASE URL.
     *
     * - returns: Rest API base url as a string.
     */
    public func getIdPBaseUrl() -> String {
        //
        return m_idpBaseUrl
    }


    /**
     * Sets the SSO client redirect URL for this application.
     *
     * - parameter url: String to look for as the SSO redirect url.
     */
    public func setSSORedirectUrl(_ url: String) {
        //
        m_ssoRedirectUrl = url
    }


    /**
     * Returns the SSO Redirect URL as a string configured for this application.
     *
     * - returns: SSO redirect url as a string.
     */
    public func getSSORedirectUrl() -> String {
        //
        return m_ssoRedirectUrl
    }


    /**
     * Returns the SSO API logout path.
     *
     * - returns: SSO API logout path as a string.
     */
    public func getSsoLogoutPath() -> String {
        //
        return SSO_LOGOUT_API_PATH
    }


    /**
     * Returns the SSO API path.
     *
     * - returns: OAuth2 API path as a string.
     */
    public func getSsoOauth2ApiPath() -> String {
        //
        return SSO_OAUTH2_API_PATH
    }


}
