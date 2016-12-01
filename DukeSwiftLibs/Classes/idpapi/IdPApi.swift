import Foundation


/**
 * Protocol for IdP service regular API functionality.
 */
protocol IdPApi {

    func getUserInfo(callback: @escaping ((UserInfo?) -> Void))

    func getSsoUserinfoPath() -> String

}
