import Foundation
import UIKit
import DukeSwiftLibs


/**
 * View controller class for user creation and editing.
 */
class UserViewController: AbstractViewController, UITextFieldDelegate {

    var m_user: User?

    var m_actionButton: UIBarButtonItem?


    /**
     * Generic delegate method called when view is loaded.
     */
    override func viewDidLoad() {
        //
        if m_user == nil {
            //
            m_user = User()
        }
        //
        super.viewDidLoad()
    }


    /**
     * Dynamic layout handling and component creation.
     */
    override func loadView() {
        //
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        self.view = scrollView
        self.view.autoresizesSubviews = true
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(createInputField(title: "FirstName".localized, value: m_user?.firstName, action: #selector(self.givenNameEdited(_:)), editable: true))
        self.view.addSubview(createInputField(title: "LastName".localized, value: m_user?.lastName, action: #selector(self.familyNameEdited(_:)), editable: true))
        self.view.addSubview(createInputField(title: "Email".localized, value: m_user?.email, action: #selector(self.emailEdited(_:)), editable: true))
        self.view.addSubview(createInputField(title: "Description".localized, value: m_user?._description, action: #selector(self.descriptionEdited(_:)), editable: true))
        //
        if m_user?.id != nil {
            //
            self.view.addSubview(createInputField(title: "Id", value: m_user?.id, action: nil, editable: false))
        }
        //
        m_actionButton = UIBarButtonItem(title: m_user?.id != nil ? "Save".localized: "Create".localized, style: .plain, target: self, action: #selector(UserViewController.actionButtonAction(_:)))
        m_actionButton?.isEnabled = false
        self.navigationItem.rightBarButtonItem = m_actionButton
        //
        setMaxHeight(scrollView: scrollView)
    }


    override func viewWillAppear(_ animated: Bool) {
        //
        if m_user?.id != nil {
            //
            navigationItem.title = "UserInformation".localized
        } else {
            //
            navigationItem.title = "CreateUser".localized
        }
        //
        navigationItem.backBarButtonItem?.title = "Back".localized
    }


    override func viewDidAppear(_ animated: Bool) {
        //
    }


    func givenNameEdited(_ textField: UITextField) {
        //
        m_user?.firstName = textField.text
        m_actionButton?.isEnabled = true
    }


    func familyNameEdited(_ textField: UITextField) {
        //
        m_user?.lastName = textField.text
        m_actionButton?.isEnabled = true
    }


    func emailEdited(_ textField: UITextField) {
        //
        m_user?.email = textField.text
        m_actionButton?.isEnabled = true
    }


    func descriptionEdited(_ textField: UITextField) {
        //
        m_user?._description = textField.text
        m_actionButton?.isEnabled = true
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }


    /**
     * Update user action result callback function.
     *
     * - parameter success: Boolean that tells if the operation was successful.
     */
    func updateUserCallback(_ success: Bool) {
        //
        if success {
            //
            m_actionButton?.isEnabled = false
        } else {
            //
            showError(title: "UserUpdateFailed".localized, message: "PressOkToContinue".localized)
        }
    }


    /**
     * Create user action result callback function.
     *
     * - parameter success: Boolean that tells if the operation was successful.
     */
    func createUserCallback(_ success: Bool) {
        //
        if success {
            //
            m_actionButton?.isEnabled = false
        } else {
            //
            showError(title: "UserCreateFailed".localized, message: "PressOkToContinue".localized)
        }
    }


    /**
     * Callback function that is called when action button is pressed.
     */
    func actionButtonAction(_ sender: Any) {
        //
        if let user = m_user {
            //
            if user.id != nil {
                //
                RestApiImpl.shared.updateUser(user, completion: updateUserCallback(_:))
            } else {
                //
                RestApiImpl.shared.createUser(user, completion: createUserCallback(_:))
            }
        }
    }

}
