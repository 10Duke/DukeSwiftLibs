import Foundation
import EVReflection


/**
 * Class that represents the 10Duke IdP UserInfo object.
 *
 * Sample JSON response from IdP /userinfo API:
 * {
 *     "sub": "512k9dd2-b456-72j6-h44h-kkd575585999",
 *     "given_name": "John",
 *     "family_name": "Doe",
 *     "email": "john.doe@duke.com"
 * }
 *
 * The "sub" element is the logged in users UUID.
 */
public class UserInfo: EVObject {

    public var givenName: String?

    public var familyName: String?

    public var email: String?

    public var sub: String?


    /**
     * Getter for logged in users UUID.
     *
     * The 'sub' element is the same as User UUID.
     *
     * - returns: UUID as a String for the logged in user.
     */
    public func getId() -> String? {
        //
        return sub
    }

}
