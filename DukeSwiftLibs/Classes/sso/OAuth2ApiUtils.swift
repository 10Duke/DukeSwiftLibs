import Foundation
import JWTDecode


/**
 * Class that hosts Oauth2 related functions.
 */
public class OAuth2ApiUtils {

    /**
     * Singleton of the OAuth2ApiUtils class.
     */
    public static let shared = OAuth2ApiUtils()

    public let ACCESS_TOKEN = "access_token"

    public let ID_TOKEN = "id_token"

    public let EXPIRES_IN = "expires_in"

    public let TOKEN_TYPE = "token_type"

    public let DEFAULT_RESPONSE_TYPES: [String] = [ResponseType.TOKEN.rawValue, ResponseType.ID_TOKEN.rawValue]

    public let DEFAULT_SCOPES: [String] = [Scope.OPENID.rawValue, Scope.EMAIL.rawValue, Scope.PROFILE.rawValue]


    /**
     * Return API login URL.
     *
     * - returns: The login URL.
     */
    public func getLoginUrl() -> URL? {
        //
        let config = ApiConfigImpl.shared
        //
        var url: String = ""
        url += config.getIdPBaseUrl()
        url += config.getSsoOauth2ApiPath()
        url += "?client_id=\(config.getSSOClientId())"
        let responseTypes = self.DEFAULT_RESPONSE_TYPES.joined(separator: "+").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        url += "&response_type=\(responseTypes)"
        let scopes = self.DEFAULT_SCOPES.joined(separator: "+").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        url += "&scopes=\(scopes)"
        let redirectUrl = config.getSSORedirectUrl().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        url += "&redirect_uri=\(redirectUrl)"
        url += "&nonce=\(generateNonce())"
        url += "&locale=\(getLocale())"
        //
        return URL(string: url)
    }


    /**
     * Return API logout URL.
     *
     * - returns: The logout URL.
     */
    public func getLogoutUrl() -> URL? {
        //
        let config = ApiConfigImpl.shared
        //
        var url: String = ""
        url += config.getIdPBaseUrl()
        url += config.getSsoLogoutPath()
        url += "?locale=\(getLocale())"
        //
        return URL(string: url)
    }


    /**
     * Returns client locale in the xx_XX form, i.e. en_GB.
     *
     * - returns: Locale currently in use as a String.
     */
    public func getLocale() -> String {
        //
        var locale: String = ""
        //
        if let currentLanguage = Locale.current.languageCode {
            //
            locale += currentLanguage
        }
        //
        if let currentRegion = Locale.current.regionCode {
            //
            if !locale.isEmpty {
                locale += "_"
            }
            //
            locale += currentRegion
        }
        //
        return locale
    }


    /**
     * Helper function that resolves token from the given URL.
     *
     * Example callback URL:
     *  tendukeauthapp://oauth/callback#access_token=WC9zkOpA57anYEbS6vRmb3eDbac&token_type=Bearer&expires_in=31536000&state=6DA15899
     *
     * - parameter url: The URL from which to parse the parameter from.
     * - parameter parameter: The parameter name to parse.
     * - returns: String value for the parameter in case it's found, otherwise returns nil.
     */
    public func resolveParameterFromUrl(url: URL, parameter: String) -> String? {
        //
        let urlString: String = url.absoluteString
        //
        if urlString.hasPrefix(ApiConfigImpl.shared.getSSORedirectUrl()) {
            //
            let needle: Character = "&"
            let range = urlString.range(of: "\(parameter)=")!
            //
            let startIndex = range.upperBound
            //
            let urlSubString = urlString.substring(from: startIndex)
            //
            if let endIndex = urlSubString.characters.index(of: needle) {
                //
                let value = urlSubString.substring(to: endIndex)
                return value
            } else {
                //
                let endIndex = urlSubString.endIndex
                let value = urlSubString.substring(to: endIndex)
                return value
            }
        }
        return nil
    }


    /**
     * Function for decoding the JWT token to cleartext format.
     */
    public func decodeToken(_ token: String) -> JWT? {
        //
        do {
            let jwt = try decode(jwt: token)
            return jwt
        } catch let error {
            //
            print("ERROR: Decodig token failed with error: \(error)")
        }
        //
        return nil
    }


    /**
     * Function that generates a unique nonce that can be used in requests.
     *
     * - returns: Random nonce as a String.
     */
    public func generateNonce() -> String {
        return NSUUID().uuidString
    }

}
