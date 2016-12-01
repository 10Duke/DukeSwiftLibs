import Foundation
import EVReflection


/**
 * Class that reflects 10Duke Organization object model.
 */
public class Organization: EVObject {

    public var name: String?

    public var founded: String?

    public var _description: String?

    public var id: String?

    public var type: String?

    public var groups: [Group]?


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
