import Foundation


/**
 * ApiConfig protocol that describes the public functions.
 */
protocol ApiConfig {

    func setSSOClientId(_ id: String)

    func getSSOClientId() -> String

    func setIdPBaseUrl(_ baseUrl: String)

    func getIdPBaseUrl() -> String

    func getSsoOauth2ApiPath() -> String

    func setSSORedirectUrl(_ url: String)

    func getSSORedirectUrl() -> String

    func getSsoLogoutPath() -> String
    
}
