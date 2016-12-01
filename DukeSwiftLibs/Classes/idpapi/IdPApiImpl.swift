import Foundation
import Alamofire
import SwiftyJSON


/**
 * API class for IdP service regular REST APIs.
 */
public class IdPApiImpl: IdPApi {

    /**
     * Singleton instance for the generic IdPAPI.
     */
    public static let shared = IdPApiImpl()

    /**
     * The userinfo API path.
     */
    let SSO_USERINFO_API_PATH = "userinfo"


    /**
     * Returns the SSO API Userinfo path.
     */
    public func getSsoUserinfoPath() -> String {
        //
        return SSO_USERINFO_API_PATH
    }


    /**
     * Makes a request to generic IdP service /userinfo API and returns UserInfo object.
     *
     * The API responses "sub" element contains logged in users UUID.
     * - parameter callback: The callback function for returning async data.
     */
    public func getUserInfo(callback: @escaping ((UserInfo?) -> Void)) {
        //
        if let requestUrl = getUserInfoUrl() {
            //
            Alamofire.request(requestUrl, headers: getHeaders()).responseJSON { response in
                //
                debugPrint(response)
                //
                switch response.result {
                    case .success(let value):
                        //
                        let json = JSON(value)
                        let userInfo = UserInfo(json: json.rawString())
                        callback(userInfo)
                    case .failure(let _):
                        //
                        callback(nil)
                }
            }
        }
    }


    /**
     * Return userinfo URL for the API.
     *
     * - returns: The /userinfo API URL.
     */
    func getUserInfoUrl() -> URL? {
        //
        var url: String = ""
        url += ApiConfigImpl.shared.getIdPBaseUrl()
        url += getSsoUserinfoPath()
        //
        return URL(string: url)
    }


    /**
     * Return HTTP headers related to API request.
     *
     * - returns: The HTTP headers that can be used in making authenticated requests.
     */
    func getHeaders() -> HTTPHeaders? {
        //
        if let token = ApiTokenImpl.shared.getToken() {
            //
            let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(token)",
                    "Accept": "application/json"
            ]
            //
            return headers
        }
        //
        return nil
    }

}
