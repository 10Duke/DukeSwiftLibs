import Foundation
import Alamofire

/**
 * Protocol for RestApi functionality.
 */
protocol RestApi {


    /**
     * USER APIS
     */

    func createUser(_ user: User, completion: @escaping (Bool) -> Void)

    func updateUser(_ user: User, completion: @escaping (Bool) -> Void)

    func deleteUser(_ user: User, completion: @escaping (Bool) -> Void)

    func getUser(id: String, completion: @escaping (User?) -> Void)

    func getUsers(completion: @escaping ([User]?) -> Void)


    /**
     * GROUP APIS
     */

    func createGroup(_ group: Group, completion: @escaping (Bool) -> Void)

    func updateGroup(_ group: Group, completion: @escaping (Bool) -> Void)

    func deleteGroup(_ group: Group, completion: @escaping (Bool) -> Void)

    func getGroups(completion: @escaping ([Group]?) -> Void)


    /**
     * ROLE APIS
     */

    func createRole(_ role: Role, completion: @escaping (Bool) -> Void)

    func updateRole(_ role: Role, completion: @escaping (Bool) -> Void)

    func deleteRole(_ role: Role, completion: @escaping (Bool) -> Void)

    func getRoles(completion: @escaping ([Role]?) -> Void)


    /**
     * ORGANIZATION APIS
     */

    func createOrganization(_ organization: Organization, completion: @escaping (Bool) -> Void)

    func updateOrganization(_ organization: Organization, completion: @escaping (Bool) -> Void)

    func deleteOrganization(_ organization: Organization, completion: @escaping (Bool) -> Void)

    func getOrganizations(completion: @escaping ([Organization]?) -> Void)

}
