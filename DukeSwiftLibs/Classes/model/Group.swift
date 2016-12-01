import Foundation
import EVReflection


/**
 * Class that reflects 10Duke Group object model.
 */
public class Group: EVObject {

    public var userIds: [String] = []

    public var name: String?

    public var id: String?

    public var ref_Organization_id: String?

    public var _description: String?

    public var type: String?


    /**
     * Skip nil values when serializing.
     */
    override open func skipPropertyValue(_ value: Any, key: String) -> Bool {
        //
        if value is NSNull {
            //
            return true
        }
        //
        return false
    }

}
