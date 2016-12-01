import Foundation

/**
 * Protocol definition for ApiToken implementations.
 */
protocol ApiToken {

    func getToken() -> String?

    func storeToken(id: String, token: String) -> Bool

    func resetToken()

    func getUserId() -> String?

}
