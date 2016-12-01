import Foundation
import UIKit
import DukeSwiftLibs


/**
 * View controller class for role creation and editing.
 */
class RoleViewController: AbstractViewController, UITextFieldDelegate {

    var m_role: Role?

    var m_actionButton: UIBarButtonItem?


    /**
     * Generic delegate method called when view is loaded.
     */
    override func viewDidLoad() {
        //
        if m_role == nil {
            m_role = Role()
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
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(createInputField(title: "Name".localized, value: m_role?.name, action: #selector(self.nameEdited(_:)), editable: true))
        self.view.addSubview(createInputField(title: "Description".localized, value: m_role?._description, action: #selector(self.descriptionEdited(_:)), editable: true))
        //
        if m_role?.id != nil {
            self.view.addSubview(createInputField(title: "Id".localized, value: m_role?.id, action: nil, editable: false))
        }
        //
        m_actionButton = UIBarButtonItem(title: m_role?.id != nil ? "Save".localized : "Create".localized, style: .plain, target: self, action: #selector(RoleViewController.actionButtonAction(_:)))
        m_actionButton?.isEnabled = false
        self.navigationItem.rightBarButtonItem = m_actionButton
        //
        setMaxHeight(scrollView: scrollView)
    }


    override func viewWillAppear(_ animated: Bool) {
        //
        if m_role?.id != nil {
            //
            navigationItem.title = "RoleInformation".localized
        } else {
            //
            navigationItem.title = "CreateRole".localized
        }
        //
        navigationItem.backBarButtonItem?.title = "Back".localized
    }


    override func viewDidAppear(_ animated: Bool) {
        //
    }


    func nameEdited(_ textField: UITextField) {
        //
        m_role?.name = textField.text
        m_actionButton?.isEnabled = true
    }


    func descriptionEdited(_ textField: UITextField) {
        //
        m_role?._description = textField.text
        m_actionButton?.isEnabled = true
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }


    /**
     * Role update action result callback function.
     *
     * - parameter success: Boolean that tells if the operation was successful.
     */
    func updateRoleCallback(_ success: Bool) {
        //
        if success {
            //
            m_actionButton?.isEnabled = false
        } else {
            //
            showError(title: "RoleUpdateFailed".localized, message: "PressOkToContinue".localized)
        }
    }

    /**
     * Role create action result callback function.
     *
     * - parameter success: Boolean that tells if the operation was successful.
     */
    func createRoleCallback(_ success: Bool) {
        //
        if success {
            //
            m_actionButton?.isEnabled = false
        } else {
            //
            showError(title: "RoleCreateFailed".localized, message: "PressOkToContinue".localized)
        }
    }



    /**
     * Callback function that is called when action button is pressed.
     */
    func actionButtonAction(_ sender: UIButton) {
        //
        if let role = m_role {
            //
            if role.id != nil {
                //
                RestApiImpl.shared.updateRole(role, completion: updateRoleCallback(_:))
            } else {
                //
                RestApiImpl.shared.createRole(role, completion: createRoleCallback(_:))
            }
        }
    }

}
