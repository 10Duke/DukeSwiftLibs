import Foundation
import UIKit
import DukeSwiftLibs


/**
 * List view controller for listing Users, Groups, Roles and Organizations.
 */
class ListViewController: UITableViewController {

    var m_type: UIActionType?

    var m_users: [User]?

    var m_groups: [Group]?

    var m_roles: [Role]?

    var m_organizations: [Organization]?

    var m_toUser: User?

    var m_toGroup: Group?

    var m_toRole: Role?

    var m_toOrganization: Organization?

    var m_deleteIndex: Int?

    @IBOutlet var m_tableView: UITableView!


    /**
     * Generic delegate method called when view is loaded.
     */
    override func viewDidLoad() {
        //
        super.viewDidLoad()
        m_tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        m_tableView.delegate = self
    }


    /**
     * Groups API callback function.
     */
    func groupsCallback(_ groups: [Group]?) {
        //
        if let respGroups = groups {
            //
            m_groups = respGroups
            m_tableView.reloadData()
        } else {
            //
            showError(title: "GroupsReadFailed".localized, message: "PressOkToContinue".localized, callback: errorCallback(_:))
        }
    }


    /**
     * Roles API callback function.
     */
    func rolesCallback(_ roles: [Role]?) {
        //
        if let respRoles = roles {
            //
            m_roles = respRoles
            m_tableView.reloadData()
        } else {
            //
            showError(title: "RolesReadFailed".localized, message: "PressOkToContinue".localized, callback: errorCallback(_:))
        }
    }


    /**
     * Users API callback function.
     */
    func usersCallback(_ users: [User]?) {
        //
        if let respUsers = users {
            //
            m_users = respUsers
            m_tableView.reloadData()
        } else {
            //
            showError(title: "UsersReadFailed".localized, message: "PressOkToContinue".localized, callback: errorCallback(_:))
        }
    }

    /**
     * Organizations API callback function.
     */
    func organizationsCallback(_ organizations: [Organization]?) {
        //
        if let respOrganizations = organizations {
            //
            m_organizations = respOrganizations
            m_tableView.reloadData()
        } else {
            //
            showError(title: "OrganizationsReadFailed".localized, message: "PressOkToContinue".localized, callback: errorCallback(_:))
        }
    }


    /**
     * Function that resets the selection variables to nil.
     */
    func resetSelection() {
        //
        m_toUser = nil
        m_toRole = nil
        m_toGroup = nil
        m_toOrganization = nil
    }


    /**
     * Create action.
     */
    func create(_ uiBarButtonItem: UIBarButtonItem) {
        //
        resetSelection()
        //
        switch m_type! {
            case .USERS:
                //
                performSegue(withIdentifier: "ListToUser", sender: "user")
            case .GROUPS:
                //
                performSegue(withIdentifier: "ListToGroup", sender: "group")
            case .ROLES:
                //
                performSegue(withIdentifier: "ListToRole", sender: "role")
            case .ORGANIZATIONS:
                //
                performSegue(withIdentifier: "ListToOrganization", sender: "organization")
            default:
                //
                print("ERROR: Create has nowhere to go with type: \(m_type)")
        }
    }


    /**
     * Defines number of rows in section.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        switch m_type! {
            case .USERS:
                //
                if let users = m_users {
                    return users.count
                }
            case .GROUPS:
                //
                if let groups = m_groups {
                    return groups.count
                }
            case .ROLES:
                //
                if let roles = m_roles {
                    return roles.count
                }
            case .ORGANIZATIONS:
                //
                if let organizations = m_organizations {
                    return organizations.count
                }
            default:
                //
                return 0
        }
        //
        return 0
    }


    /**
     * Navigation title and navigation button setup.
     */
    override func viewWillAppear(_ animated: Bool) {
        //
        let restApi = RestApiImpl.shared
        //
        switch m_type! {
            case .GROUPS:
                //
                navigationItem.title = "Groups".localized
                restApi.getGroups(completion: groupsCallback(_:))
            case .USERS:
                //
                navigationItem.title = "Users".localized
                restApi.getUsers(completion: usersCallback(_:))
            case .ROLES:
                //
                navigationItem.title = "Roles".localized
                restApi.getRoles(completion: rolesCallback(_:))
            case .ORGANIZATIONS:
                //
                navigationItem.title = "Organizations".localized
                restApi.getOrganizations(completion: organizationsCallback(_:))
            default:
                //
                navigationItem.title = "Error".localized
        }
        //
        navigationItem.backBarButtonItem?.title = "Back".localized
        //
        let createButton = UIBarButtonItem(title: "Create".localized, style: .plain, target: self, action: #selector(ListViewController.create(_:)))
        self.navigationItem.rightBarButtonItem = createButton
    }


    /**
     * Cell population.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        //
        if let user = m_users?[indexPath.row] {
            //
            var fullName: String = ""
            //
            if let firstName = user.firstName {
                //
                fullName.append(firstName)
            }
            //
            if let lastName = user.lastName {
                //
                if !fullName.isEmpty {
                    fullName.append(" ")
                }
                fullName.append(lastName)
            }
            //
            cell.textLabel?.text = fullName
        } else if let group = m_groups?[indexPath.row] {
            //
            cell.textLabel?.text = group.name
        } else if let role = m_roles?[indexPath.row] {
            //
            cell.textLabel?.text = role.name
        } else if let organization = m_organizations?[indexPath.row] {
            //
            cell.textLabel?.text = organization.name
        }
        //
        return cell
    }


    /**
     * Row selection callback function.
     */
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        switch m_type! {
            case .USERS:
                //
                if let user = m_users?[indexPath.row] {
                    //
                    m_toUser = user
                    //
                    performSegue(withIdentifier:"ListToUser", sender: nil)
                }
            case .GROUPS:
                //
                if let group = m_groups?[indexPath.row] {
                    //
                    m_toGroup = group
                    //
                    performSegue(withIdentifier: "ListToGroup", sender: nil)
                }
            case .ROLES:
                //
                if let role = m_roles?[indexPath.row] {
                    //
                    m_toRole = role
                    //
                    performSegue(withIdentifier: "ListToRole", sender: nil)
                }
            case .ORGANIZATIONS:
                //
                if let organization = m_organizations?[indexPath.row] {
                    //
                    m_toOrganization = organization
                    //
                    performSegue(withIdentifier: "ListToOrganization", sender: nil)
                }
            default:
                //
                print("Unsupported cell type at didSelectRowAt: \(m_type)")
        }
    }


    /**
     * Segue preparation, provide data to editor view.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        if segue.identifier == "ListToUser" {
            //
            if let userVC = segue.destination as? UserViewController {
                //
                userVC.m_user = m_toUser
            }
        } else if segue.identifier == "ListToGroup" {
            //
            if let groupVC = segue.destination as? GroupViewController {
                //
                groupVC.m_group = m_toGroup
            }
        } else if segue.identifier == "ListToRole" {
            //
            if let roleVC = segue.destination as? RoleViewController {
                //
                roleVC.m_role = m_toRole
            }
        } else if segue.identifier == "ListToOrganization" {
            //
            if let roleVC = segue.destination as? OrganizationViewController {
                //
                roleVC.m_organization = m_toOrganization
            }
        }
    }


    /**
     * Enable deleting of cells.
     */
    override public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //
        return true
    }


    /**
     * Callback function for deleting from the list.
     */
    func deleteComplete(_ success: Bool) {
        //
        if success {
            //
            if let deleteIndex = m_deleteIndex {
                //
                switch m_type! {
                    case .GROUPS:
                        //
                        m_groups?.remove(at: deleteIndex)
                    case .USERS:
                        //
                        m_users?.remove(at: deleteIndex)
                    case .ROLES:
                        //
                        m_roles?.remove(at: deleteIndex)
                    case .ORGANIZATIONS:
                        //
                        m_organizations?.remove(at: deleteIndex)
                    default:
                        //
                        print("ERROR: Not sure what to delete?")
                }
            } else {
                //
                print("ERROR: Delete failed, no index.")
            }
        } else {
            //
            switch m_type! {
                case .GROUPS:
                    //
                    showError(title: "GroupDeleteFailed".localized, message: "PressOkToContinue")
                case .USERS:
                    //
                    showError(title: "UserDeleteFailed".localized, message: "PressOkToContinue")
                case .ROLES:
                    //
                    showError(title: "RoleDeleteFailed".localized, message: "PressOkToContinue")
                case .ORGANIZATIONS:
                    //
                    showError(title: "OrganizationDeleteFailed".localized, message: "PressOkToContinue")
                default:
                    //
                    print("ERROR: Unknown type in delete: \(m_type)")
            }
        }
        m_deleteIndex = nil
        self.tableView.reloadData()
    }


    /**
     * Delete trigger for this particular row.
     *
     * An UI alert is presented for the user for double checking the delete with Yes / Cancel options.
     */
    override public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //
        m_deleteIndex = indexPath.row
        //
        let restApi = RestApiImpl.shared
        //
        let alert = UIAlertController(title: "AreYouSureTitle".localized, message: "AreYouSureMessage".localized, preferredStyle: UIAlertControllerStyle.alert)
        //
        let alertAction = UIAlertAction(title: "Yes".localized, style: UIAlertActionStyle.default) { (action) in
            //
            switch self.m_type! {
                case .USERS:
                    if let user = self.m_users?[self.m_deleteIndex!] {
                        //
                        restApi.deleteUser(user, completion: self.deleteComplete)
                    }
                case .ROLES:
                    if let role = self.m_roles?[self.m_deleteIndex!] {
                        //
                        restApi.deleteRole(role, completion: self.deleteComplete)
                    }
                case .GROUPS:
                    if let group = self.m_groups?[self.m_deleteIndex!] {
                        //
                        restApi.deleteGroup(group, completion: self.deleteComplete)
                    }
                case .ORGANIZATIONS:
                    if let organization = self.m_organizations?[self.m_deleteIndex!] {
                        //
                        restApi.deleteOrganization(organization, completion: self.deleteComplete)
                    }
                default:
                    //
                    print("Unsupported cell type at commit editingStyle: \(self.m_type)")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.destructive) {
            (UIAlertAction) -> Void in
        }
        //
        alert.addAction(alertAction)
        alert.addAction(cancelAction)
        //
        present(alert, animated: true) {
            () -> Void in
        }
    }


    /**
     * The error callback that pops the list screen away.
     */
    func errorCallback(_ alertAction: UIAlertAction) {
        //
        if let navController = self.navigationController {
            //
            navController.popViewController(animated: true)
        }
    }


    /**
     * Shows an alert error with title and message on screen with an Ok button to continue.
     */
    func showError(title: String, message: String) {
        //
        showError(title: title, message: message, callback: nil)
    }


    /**
     * Shows an alert error with title and message on screen with an Ok button to continue.
     *
     * - parameter title: The title text of the alert.
     * - parameter message: The message text of the alert.
     * - parameter callback: The callback to be called when user presses the action button on the alert.
     */
    //func showError(title: String, message: String, callback: @escaping ((UIAlertAction) -> Void)!) {
    func showError(title: String, message: String, callback: ((UIAlertAction) -> Void)!) {
        //
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        //
        let alertAction = UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: callback)
        //
        alert.addAction(alertAction)
        //
        present(alert, animated: true, completion: nil)
    }

}
