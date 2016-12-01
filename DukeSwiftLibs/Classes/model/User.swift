import Foundation
import EVReflection


/**
 * Class that reflects 10Duke User object model.
 */
public class User: EVObject {

    public var id: String?

    public var type: String?

    public var givenName: String?

    public var familyName: String?

    public var firstName: String?

    public var lastName: String?

    public var email: String?

    public var displayName: String?

    public var _description: String?

    public var validUntil: String?

    public var validFrom: String?

    public var temporaryPassword: String?

//    public var groups: [Group]?


    /**
     * Skip nil values when serializing.
     */
    override open func skipPropertyValue(_ value: Any, key: String) -> Bool {
        //
//        if key == "groups" {
//            //
//            return true
//        }
        //
        if value is NSNull {
            //
            return true
        }
        //
        return false
    }

}
