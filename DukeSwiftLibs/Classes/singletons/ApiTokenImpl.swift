import Foundation
import Locksmith


/**
 * Class for handling OAuth2 API token and it's secure persistence.
 */
public class ApiTokenImpl: ApiToken {

    /**
     * Singleton instance of the ApiToken class.
     */
    public static let shared = ApiTokenImpl()

    /**
     * Static string for idpToken, used for keychain storage data key.
     */
    let IDP_TOKEN = "idpToken"

    /**
     * Static string for userId, used for defaults storage key.
     */
    let IDP_USERID = "userId"

    /**
     * Defaults that is used for storing user UUID.
     */
    let m_defaults = UserDefaults()


    /**
     * OAuth2 token.
     *
     * In case memory stored token exists, returns it, otherwise tries to look it up from keychain based
     * on earlier login related UUID.
     * - returns: OAuth2 Bearer token as a string and nil in case no token is fond.
     */
    public func getToken() -> String? {
        //
        if let id = m_defaults.string(forKey: IDP_USERID) {
            if let dictionary = Locksmith.loadDataForUserAccount(userAccount: id) {
                //
                if let token = dictionary["\(IDP_TOKEN)"] as? String {
                    //
                    if token == "" {
                        return nil
                    }
                    return token
                }
            }
        }
        //
        return nil
    }


    /**
     * Stores token to specific UUID.
     *
     * - parameter id: The UUID of the logged in user.
     * - parameter token: The token string to be stored.
     * - returns: Boolean true if token storing is successful, false if it fails.
     */
    public func storeToken(id: String, token: String) -> Bool {
        //
        print("ApiTokenImpl storeToken called with id: \(id) and token: \(token)")
        //
        do {
            //
            m_defaults.setValue(id, forKey: IDP_USERID)
            try Locksmith.updateData(data: [IDP_TOKEN: token], forUserAccount: id)
            return true
        } catch let error {
            //
            print("ERROR: Storing token failed with error: \(error)")
            return false
        }
    }


    /**
     * Resets and clears the token and user information from defaults and keychain.
     *
     * This function resets the memory stored token and alcso clears the keychain of the user.
     */
    public func resetToken() {
        //
        if let id = m_defaults.string(forKey: IDP_USERID) {
            //
            do {
                //
                //try Locksmith.updateData(data: [IDP_TOKEN: ""], forUserAccount: id)
                try Locksmith.deleteDataForUserAccount(userAccount: id)
                m_defaults.removeObject(forKey: IDP_USERID)
            } catch let error {
                //
                print("ERROR: Resetting token failed with error: \(error)")
            }
        }
    }


    /**
     * Getter for user id stored in defaults.
     */
    public func getUserId() -> String? {
        //
        if let userId = m_defaults.string(forKey: IDP_USERID) {
            //
            return userId
        }
        //
        return nil
    }


}
