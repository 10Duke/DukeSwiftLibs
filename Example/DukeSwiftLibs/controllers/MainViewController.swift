import UIKit
import Alamofire
import WebKit
import SwiftyJSON
import DukeSwiftLibs


/**
 * Main view controller class that acts as the main user interface upon client startup.
 */
class MainViewController: AbstractViewController, WKUIDelegate {

    var m_username: String?

    /**
     * UI components.
     */

    var m_statusLabel: UILabel?

    var m_myUserButton: UIButton?

    var m_usersButton: UIButton?

    var m_groupsButton: UIButton?

    var m_rolesButton: UIButton?

    var m_organizationsButton: UIButton?


    /**
     * Dynamic layout handling.
     */
    override func loadView() {
        //
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        self.view = scrollView
        self.view.autoresizingMask = UIViewAutoresizing.flexibleRightMargin
        self.view.autoresizesSubviews = true
        self.view.backgroundColor = UIColor.white
        //
        let imageView = createImage(imageName: "10duke")
        self.view.addSubview(imageView)
        //
        let statusLabelView = createLabel(title: "")
        m_statusLabel = statusLabelView.subviews.first as? UILabel
        self.view.addSubview(statusLabelView)
        //
        let myUserButtonView = createActionButton(title: "MyUser".localized, action: #selector(myUserAction(_:)), enabled: true)
        m_myUserButton = myUserButtonView.subviews.first as? UIButton
        self.view.addSubview(myUserButtonView)
        //
        let usersButtonView = createActionButton(title: "Users".localized, action: #selector(usersAction(_:)), enabled: true)
        m_usersButton = usersButtonView.subviews.first as? UIButton
        self.view.addSubview(usersButtonView)
        //
        let groupsButtonView = createActionButton(title: "Groups".localized, action: #selector(groupsAction(_:)), enabled: true)
        m_groupsButton = groupsButtonView.subviews.first as? UIButton
        self.view.addSubview(groupsButtonView)
        //
        let rolesButtonView = createActionButton(title: "Roles".localized, action: #selector(rolesAction(_:)), enabled: true)
        m_rolesButton = rolesButtonView.subviews.first as? UIButton
        self.view.addSubview(rolesButtonView)
        //
        let organizationsButtonView = createActionButton(title: "Organizations".localized, action: #selector(organizationsAction(_:)), enabled: true)
        m_organizationsButton = organizationsButtonView.subviews.first as? UIButton
        self.view.addSubview(organizationsButtonView)
        //
        setMaxHeight(scrollView: scrollView)
    }


    /**
     * Action for Login / Logout bar button.
     */
    func actionButtonAction(_ sender: UIButton) {
        //
        let sso = SSOImpl.shared
        //
        if sso.isUserLoggedIn() {
            //
            sso.logout(controller: self.navigationController!)
        } else {
            //
            sso.login(controller: self.navigationController!)
        }
    }


    /**
     * Action for showing MyUser view.
     */
    func myUserAction(_ sender: UIButton) {
        //
        if let id = ApiTokenImpl.shared.getUserId() {
            //
            RestApiImpl.shared.getUser(id: id, completion: userCallback(_:))
        }
    }


    /**
     * User data callback after pressing my user button.
     *
     * - parameter user: User object returned from the REST API.
     */
    func userCallback(_ user: User?) {
        //
        if let myUser = user {
            //
            let storyboard = UIStoryboard(name: "10Duke", bundle: nil)
            let userViewController = storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
            userViewController.m_user = myUser
            self.navigationController?.pushViewController(userViewController, animated: true)
        } else {
            //
            showError(title: "UserReadFailed".localized, message: "PressOkToContinue".localized)
        }
    }


    /**
     * Action for showing user listing.
     */
    func usersAction(_ sender: UIButton) {
        //
        openListController(type: UIActionType.USERS)
    }


    /**
     * Action for showing group listing.
     */
    func groupsAction(_ sender: UIButton) {
        //
        openListController(type: UIActionType.GROUPS)
    }


    /**
     * Action for showing roles listing.
     */
    func rolesAction(_ sender: UIButton) {
        //
        openListController(type: UIActionType.ROLES)
    }


    /**
     * Action for showing organizations listing.
     */
    func organizationsAction(_ sender: UIButton) {
        //
        openListController(type: UIActionType.ORGANIZATIONS)
    }


    /**
     * Helper function that shows listview UI with typed content.
     *
     * - parameter type: Type of list view to open.
     */
    func openListController(type: UIActionType) {
        //
        let storyboard = UIStoryboard(name: "10Duke", bundle: nil)
        let listViewController = storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        listViewController.m_type = type
        self.navigationController?.pushViewController(listViewController, animated: true)
    }


    /**
     * Callback for receiving user from REST API.
     *
     * - parameter user: User object.
     */
    func userDataCallback(user: User?) {
        //
        if let myUser = user {
            //
            m_statusLabel?.textColor = UIColor.gray
            //
            if let username = myUser.firstName {
                m_username = username
            } else {
                m_username = nil
            }
            //
            resetButtons()
        } else {
            //
            m_statusLabel?.text = "Login failed...".localized
            m_statusLabel?.textColor = UIColor.red
        }
    }


    /**
     * Fetches user data.
     *
     * The REST API /users/<userid> API is called here to get user information.
     */
    func ensureUserData() {
        //
        if let id = ApiTokenImpl.shared.getUserId() {
            RestApiImpl.shared.getUser(id: id, completion: userDataCallback)
        }
    }


    /**
     * Resets UI buttons based on token being present (user being logged in).
     */
    func resetButtons() {
        //
        if ApiTokenImpl.shared.getToken() != nil {
            //
            let actionButton = UIBarButtonItem(title: "Logout".localized, style: .plain, target: self, action: #selector(MainViewController.actionButtonAction(_:)))
            self.navigationItem.leftBarButtonItem = actionButton
            //
            m_statusLabel?.text = m_username != nil ? String(format: NSLocalizedString("LoggedInWithUser", comment: ""), m_username!) : "LoggedIn".localized
            m_myUserButton?.isEnabled = true
            m_myUserButton?.isHidden = false
            m_usersButton?.isEnabled = true
            m_usersButton?.isHidden = false
            m_groupsButton?.isEnabled = true
            m_groupsButton?.isHidden = false
            m_rolesButton?.isEnabled = true
            m_rolesButton?.isHidden = false
            m_organizationsButton?.isEnabled = true
            m_organizationsButton?.isHidden = false
        } else {
            //
            let actionButton = UIBarButtonItem(title: "Login".localized, style: .plain, target: self, action: #selector(MainViewController.actionButtonAction(_:)))
            self.navigationItem.leftBarButtonItem = actionButton
            //
            m_statusLabel?.text = "NotLoggedIn".localized
            m_myUserButton?.isEnabled = false
            m_myUserButton?.isHidden = true
            m_usersButton?.isEnabled = false
            m_usersButton?.isHidden = true
            m_groupsButton?.isEnabled = false
            m_groupsButton?.isHidden = true
            m_rolesButton?.isEnabled = false
            m_rolesButton?.isHidden = true
            m_organizationsButton?.isEnabled = false
            m_organizationsButton?.isHidden = true
        }
    }


    override func viewDidLoad() {
        //
        super.viewDidLoad()
        //
        ensureUserData()
        resetButtons()
    }


    override func viewWillAppear(_ animated: Bool) {
        //
        navigationItem.title = "10Duke IdP"
        navigationItem.backBarButtonItem?.title = "Back".localized
        //
        ensureUserData()
        resetButtons()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
