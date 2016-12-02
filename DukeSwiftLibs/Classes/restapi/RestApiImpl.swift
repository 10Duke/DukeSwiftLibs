import Foundation
import Alamofire
import SwiftyJSON


/**
 * Collection of functions to return data from REST API.
 */
public class RestApiImpl: RestApi {

    /**
     * Singleton instance of the RestApiImpl class.
     */
    public static let shared = RestApiImpl()


    /**
     * IdP REST API base path.
     */
    let IDP_BASE_API_PATH = "api/idp/"

    /**
     * IdP REST API version.
     */
    let IDP_API_VERSION_PATH = "v1/"

    /**
     * IdP REST API users path.
     */
    let IDP_USERS_API_PATH = "users"

    /**
     * IdP REST API groups path.
     */
    let IDP_GROUPS_API_PATH = "groups"

    /**
     * IdP REST API roles path.
     */
    let IDP_ROLES_API_PATH = "roles"

    /**
     * IdP REST API organizations path.
     */
    let IDP_ORGANIZATIONS_API_PATH = "organizations"


    /**
     * Returns the SSO API BASE URL.
     */
    public func getIdPApiPath() -> String {
        //
        let apiPath = IDP_BASE_API_PATH + IDP_API_VERSION_PATH
        //
        return apiPath
    }


    /**
     * Returns the SSO USERS API path.
     */
    public func getUsersApiPath() -> String {
        //
        return IDP_USERS_API_PATH
    }


    /**
     * Returns the SSO GROUPS API path.
     */
    public func getGroupsApiPath() -> String {
        //
        return IDP_GROUPS_API_PATH
    }


    /**
     * Returns the SSO ROLES API path.
     */
    public func getRolesApiPath() -> String {
        //
        return IDP_ROLES_API_PATH
    }


    /**
     * Returns the SSO ORGANIZATIONS API path.
     */
    public func getOrganizationsApiPath() -> String {
        //
        return IDP_ORGANIZATIONS_API_PATH
    }


    /**
     * USER APIS
     */

    /**
     * Creates a new user.
     *
     * - parameter user: The user object that is being created.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func createUser(_ user: User, completion: @escaping (Bool) -> Void) {
        //
        if let requestUrl = getUsersUrl() {
            //
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = getHeaders()
            //
            let userData = fixDesc(user.toJsonString([.DefaultSerialize]))
            //
            request.httpBody = userData.data(using: String.Encoding.utf8)
            //
            Alamofire.request(request).responseJSON { response in
                switch response.result {
                    case .success(let value):
                        //
                        completion(true)
                    case .failure(let error):
                        //
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            //
                            print(responseString)
                        }
                        //
                        completion(false)
                }
            }
        }
    }


    /**
     * Updates an existing user.
     *
     * - parameter user: The user object that is being updated.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func updateUser(_ user: User, completion: @escaping (Bool) -> Void) {
        //
        if let requestUrl = getUsersUrl() {
            //
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = getHeaders()
            //
            let userData = fixDesc(user.toJsonString([.DefaultSerialize]))
            //
            request.httpBody = userData.data(using: String.Encoding.utf8)
            //
            Alamofire.request(request).responseJSON { response in
                switch response.result {
                    case .success(let value):
                        //
                        completion(true)
                    case .failure(let error):
                        //
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            //
                            print(responseString)
                        }
                        //
                        completion(false)
                }
            }
        }
    }


    /**
     * Deletes an existing user.
     *
     * - parameter user: The user object that is being deleted.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func deleteUser(_ user: User, completion: @escaping (Bool) -> Void) {
        //
        if var requestUrl = getUsersUrl() {
            //
            if let id = user.id {
                //
                requestUrl.appendPathComponent(id)
                //
                Alamofire.request(requestUrl, method: .delete, headers: getHeaders()).responseJSON { response in
                    debugPrint(response)
                    switch response.result {
                        case .success(let value):
                            //
                            completion(true)
                        case .failure(let error):
                            //
                            completion(false)
                    }
                }
            }
        }
    }



    /**
     * Returns an existing user from REST API.
     *
     * - parameter id: The requested user UUID in string format.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func getUser(id: String, completion: @escaping (User?) -> Void) {
        //
        print("getUser with id \(id)")
        //
        if var requestUrl = getUsersUrl() {
            //
            requestUrl.appendPathComponent(id)
            //
            Alamofire.request(requestUrl, headers: getHeaders()).responseJSON { response in
                debugPrint(response)
                switch response.result {
                    case .success(let value):
                        //
                        let json = JSON(value)
                        //
                        if let code = json["code"].int {
                            //
                            if code >= 200 || code > 300{
                                //
                                completion(nil)
                                return
                            }
                        }
                        //
                        let user = User(json: json.rawString())
                        completion(user)
                    case .failure(let error):
                        //
                        completion(nil)
                }
            }
        }
    }


    /**
     * Fetches a list of users from REST API.
     *
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func getUsers(completion: @escaping ([User]?) -> Void) {
        //
        var users: [User]?
        //
        if let requestUrl = getUsersUrl() {
            //
            Alamofire.request(requestUrl, headers: getHeaders()).responseJSON { response in
                debugPrint(response)
                switch response.result {
                    case .success(let value):
                        //
                        let json = JSON(value)
                        //
                        if let code = json["code"].int {
                            //
                            if code >= 200 || code > 300{
                                //
                                completion(nil)
                                return
                            }
                        }
                        //
                        users = [User](json: json.rawString())
                        completion(users)
                    case .failure(let error):
                        //
                        completion(nil)
                }
            }
        }
    }


    /**
     * GROUP APIS
     */

    /**
     * Creates a new group.
     *
     * - parameter group: The group object that is being created.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func createGroup(_ group: Group, completion: @escaping (Bool) -> Void) {
        //
        if let requestUrl = getGroupsUrl() {
            //
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = getHeaders()
            //
            let groupData = group.toJsonString([.DefaultSerialize])
            //
            request.httpBody = groupData.data(using: String.Encoding.utf8)
            //
            Alamofire.request(request).responseJSON { response in
                switch response.result {
                    case .success(let value):
                        //
                        completion(true)
                    case .failure(let error):
                        //
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            print(responseString)
                        }
                        //
                        completion(false)
                }
            }
        }
    }


    /**
     * Updates an existing group.
     *
     * - parameter group: The group object that is being updated.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func updateGroup(_ group: Group, completion: @escaping (Bool) -> Void) {
        //
        if let requestUrl = getGroupsUrl() {
            //
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = getHeaders()
            //
            let groupData = group.toJsonString([.DefaultSerialize])
            //
            request.httpBody = groupData.data(using: String.Encoding.utf8)
            //
            Alamofire.request(request).responseJSON { response in
                switch response.result {
                    case .success(let value):
                        //
                        completion(true)
                    case .failure(let error):
                        //
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            //
                            print(responseString)
                        }
                        //
                        completion(false)
                }
            }
        }
    }


    /**
     * Deletes an existing group.
     *
     * - parameter group: The group object that is being deleted.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func deleteGroup(_ group: Group, completion: @escaping (Bool) -> Void) {
        //
        if var requestUrl = getGroupsUrl() {
            //
            if let id = group.id {
                //
                requestUrl.appendPathComponent(id)
                //
                Alamofire.request(requestUrl, method: .delete, headers: getHeaders()).responseJSON { response in
                    debugPrint(response)
                    switch response.result {
                        case .success(let value):
                            //
                            completion(true)
                        case .failure(let error):
                            //
                            completion(false)
                    }
                }
            }
        }
    }


    /**
     * Requests a list of groups from REST API.
     *
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func getGroups(completion: @escaping ([Group]?) -> Void) {
        //
        var groups: [Group]?
        //
        if let requestUrl = getGroupsUrl() {
            //
            Alamofire.request(requestUrl, headers: getHeaders()).responseJSON { response in
                debugPrint(response)
                switch response.result {
                    case .success(let value):
                        //
                        let json = JSON(value)
                        //
                        if let code = json["code"].int {
                            //
                            if code >= 200 || code > 300{
                                //
                                completion(nil)
                                return
                            }
                        }
                        //
                        groups = [Group](json: json.rawString())
                        completion(groups)
                    case .failure(let error):
                        //
                        completion(nil)
                }
            }
        }
    }


    /**
     * ROLE APIS
     */

    /**
     * Creates a new role.
     *
     * - parameter role: The role object that is being created.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func createRole(_ role: Role, completion: @escaping (Bool) -> Void) {
        //
        if let requestUrl = getRolesUrl() {
            //
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = getHeaders()
            //
            let roleData = fixDesc(role.toJsonString([.DefaultSerialize]))
            //
            request.httpBody = roleData.data(using: String.Encoding.utf8)
            //
            Alamofire.request(request).responseJSON { response in
                switch response.result {
                    case .success(let value):
                        //
                        completion(true)
                    case .failure(let error):
                        //
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            //
                            print(responseString)
                        }
                        completion(false)
                }
            }
        }
    }


    /**
     * Update existing role.
     *
     * - parameter role: The role object that is being updated.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func updateRole(_ role: Role, completion: @escaping (Bool) -> Void) {
        //
        if let requestUrl = getRolesUrl() {
            //
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = getHeaders()
            //
            let roleData = fixDesc(role.toJsonString([.DefaultSerialize]))
            //
            request.httpBody = roleData.data(using: String.Encoding.utf8)
            //
            Alamofire.request(request).responseJSON { response in
                switch response.result {
                    case .success(let value):
                        //
                        completion(true)
                    case .failure(let error):
                        //
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            //
                            print(responseString)
                        }
                        completion(false)
                }
            }
        }
    }


    /**
     * Delete role.
     *
     * - parameter role: The role object that is being deleted.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func deleteRole(_ role: Role, completion: @escaping (Bool) -> Void) {
        //
        if var requestUrl = getRolesUrl() {
            //
            if let id = role.id {
                //
                requestUrl.appendPathComponent(id)
                //
                Alamofire.request(requestUrl, method: .delete, headers: getHeaders()).responseJSON { response in
                    debugPrint(response)
                    switch response.result {
                        case .success(let value):
                            //
                            completion(true)
                        case .failure(let error):
                            //
                            completion(false)
                        }
                }
            }
        }
    }


    /**
     * Fetches a list of roles from REST API.
     *
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func getRoles(completion: @escaping ([Role]?) -> Void) {
        //
        var roles: [Role]?
        //
        if let requestUrl = getRolesUrl() {
            //
            Alamofire.request(requestUrl, headers: getHeaders()).responseJSON { response in
                debugPrint(response)
                switch response.result {
                    case .success(let value):
                        //
                        let json = JSON(value)
                        //
                        if let code = json["code"].int {
                            //
                            if code >= 200 || code > 300{
                                //
                                completion(nil)
                                return
                            }
                        }
                        //
                        roles = [Role](json: json.rawString())
                        completion(roles)
                    case .failure(let error):
                        //
                        completion(nil)
                }
            }
        }
    }


    /**
     * ORGANIZATION APIS
     */

    /**
     * Creates a new organization.
     *
     * - parameter organization: The organization object that is being created.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func createOrganization(_ organization: Organization, completion: @escaping (Bool) -> Void) {
        //
        if let requestUrl = getOrganizationsUrl() {
            //
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = getHeaders()
            //
            let organizationData = fixDesc(organization.toJsonString([.DefaultSerialize]))
            //
            request.httpBody = organizationData.data(using: String.Encoding.utf8)
            //
            Alamofire.request(request).responseJSON { response in
                switch response.result {
                    case .success(let value):
                        //
                        completion(true)
                    case .failure(let error):
                        //
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            //
                            print(responseString)
                        }
                        //
                        completion(false)
                }
            }
        }
    }


    /**
     * Updates an existing organization.
     *
     * - parameter organization: The organization object that is being updated.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func updateOrganization(_ organization: Organization, completion: @escaping (Bool) -> Void) {
        //
        if let requestUrl = getOrganizationsUrl() {
            //
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = getHeaders()
            //
            let organizationData = fixDesc(organization.toJsonString([.DefaultSerialize]))
            //
            request.httpBody = organizationData.data(using: String.Encoding.utf8)
            //
            Alamofire.request(request).responseJSON { response in
                switch response.result {
                    case .success(let value):
                        //
                        completion(true)
                    case .failure(let error):
                        //
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            //
                            print(responseString)
                        }
                        //
                        completion(false)
                }
            }
        }
    }


    /**
     * Deletes an existing organization.
     *
     * - parameter organization: The organization object that is being deleted.
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func deleteOrganization(_ organization: Organization, completion: @escaping (Bool) -> Void) {
        //
        if var requestUrl = getOrganizationsUrl() {
            //
            if let id = organization.id {
                //
                requestUrl.appendPathComponent(id)
                //
                Alamofire.request(requestUrl, method: .delete, headers: getHeaders()).responseJSON { response in
                    debugPrint(response)
                    switch response.result {
                        case .success(let value):
                            //
                            completion(true)
                        case .failure(let error):
                            //
                            completion(false)
                    }
                }
            }
        }
    }


    /**
     * Fetches a list of organizations from REST API.
     *
     * - parameter completion: The callback function that is called when the asynchronous request is complete.
     */
    public func getOrganizations(completion: @escaping ([Organization]?) -> Void) {
        //
        var organizations: [Organization]?
        //
        if let requestUrl = getOrganizationsUrl() {
            //
            Alamofire.request(requestUrl, headers: getHeaders()).responseJSON { response in
                debugPrint(response)
                switch response.result {
                    case .success(let value):
                        //
                        let json = JSON(value)
                        //
                        if let code = json["code"].int {
                            //
                            if code >= 200 || code > 300{
                                //
                                completion(nil)
                                return
                            }
                        }
                        //
                        organizations = [Organization](json: json.rawString())
                        completion(organizations)
                    case .failure(let error):
                        //
                        completion(nil)
                }
            }
        }
    }


    /**
     * Generic helper functions.
     */

    /**
     * Return HTTP headers related to API request.
     *
     * - returns: The HTTP headers for making an authenticated API request.
     */
    func getHeaders() -> HTTPHeaders? {
        //
        if let token = ApiTokenImpl.shared.getToken() {
            //
            let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(token)",
                    "Accept": "application/json",
                    "Content-Type": "application/json"
            ]
            //
            return headers
        }
        //
        return nil
    }


    /**
     * Constructs the REST API users URL.
     *
     * - returns: The users API URL.
     */
    func getUsersUrl() -> URL? {
        //
        var url: String = ""
        url += ApiConfigImpl.shared.getIdPBaseUrl()
        url += getIdPApiPath()
        url += getUsersApiPath()
        //
        return URL(string: url)
    }


    /**
     * Constructs the REST API groups URL.
     *
     * - returns: The groups API URL.
     */
    func getGroupsUrl() -> URL? {
        //
        var url: String = ""
        url += ApiConfigImpl.shared.getIdPBaseUrl()
        url += getIdPApiPath()
        url += getGroupsApiPath()
        //
        return URL(string: url)
    }


    /**
     * Constructs REST API roles URL.
     *
     * - returns: The roles API URL.
     */
    func getRolesUrl() -> URL? {
        //
        var url: String = ""
        url += ApiConfigImpl.shared.getIdPBaseUrl()
        url += getIdPApiPath()
        url += getRolesApiPath()
        //
        return URL(string: url)
    }


    /**
     * Constructs REST API organizations URL.
     *
     * - returns: The organizations API URL.
     */
    func getOrganizationsUrl() -> URL? {
        //
        var url: String = ""
        url += ApiConfigImpl.shared.getIdPBaseUrl()
        url += getIdPApiPath()
        url += getOrganizationsApiPath()
        //
        return URL(string: url)
    }


    /**
     * Fixes underscore description field to serialize properly for the REST API JSON payload.
     *
     * - parameter json: Input JSON String that might contain underscore description key.
     * - returns: Modified JSON payload that has the description key transformed.
     */
    func fixDesc(_ json: String) -> String {
        //
        return json.replacingOccurrences(of: "\"_description\" :", with: "\"description\" :")
    }

}
