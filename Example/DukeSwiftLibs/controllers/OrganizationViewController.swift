import Foundation
import UIKit
import DukeSwiftLibs


/**
 * View controller class for organization creation and editing.
 */
class OrganizationViewController: AbstractViewController, UITextFieldDelegate {

    var m_organization: Organization?

    var m_actionButton: UIBarButtonItem?


    /**
     * Generic delegate method called when view is loaded.
     */
    override func viewDidLoad() {
        //
        if m_organization == nil {
            m_organization = Organization()
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
        self.view.addSubview(createInputField(title: "Name".localized, value: m_organization?.name, action: #selector(self.nameEdited(_:)), editable: true))
        self.view.addSubview(createInputField(title: "Description".localized, value: m_organization?._description, action: #selector(self.descriptionEdited(_:)), editable: true))
        //
        if m_organization?.id != nil {
            //
            self.view.addSubview(createInputField(title: "Id".localized, value: m_organization?.id, action: nil, editable: false))
        }
        //
        m_actionButton = UIBarButtonItem(title: m_organization?.id != nil ? "Save".localized : "Create".localized, style: .plain, target: self, action: #selector(OrganizationViewController.actionButtonAction(_:)))
        m_actionButton?.isEnabled = false
        self.navigationItem.rightBarButtonItem = m_actionButton
        //
        setMaxHeight(scrollView: scrollView)
    }


    override func viewWillAppear(_ animated: Bool) {
        //
        if m_organization?.id != nil {
            //
            navigationItem.title =  "OrganizationInformation".localized
        } else {
            //
            navigationItem.title = "CreateOrganization".localized
        }
        //
        navigationItem.backBarButtonItem?.title = "Back".localized
    }


    override func viewDidAppear(_ animated: Bool) {
        //
    }


    func nameEdited(_ textField: UITextField) {
        //
        m_organization?.name = textField.text
        m_actionButton?.isEnabled = true
    }


    func descriptionEdited(_ textField: UITextField) {
        //
        m_organization?._description = textField.text
        m_actionButton?.isEnabled = true
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }


    /**
     * Update organization action result callback function.
     *
     * - parameter success: Boolean that tells if the operation was successful.
     */
    func updateOrganizationCallback(_ success: Bool) {
        //
        if success {
            //
            m_actionButton?.isEnabled = false
        } else {
            //
            showError(title: "OrganizationUpdateFailed".localized, message: "PressOkToContinue".localized)
        }
    }


    /**
     * Create organization action result callback function.
     *
     * - parameter success: Boolean that tells if the operation was successful.
     */
    func createOrganizationCallback(_ success: Bool) {
        //
        if success {
            //
            m_actionButton?.isEnabled = false
        } else {
            //
            showError(title: "OrganizationCreateFailed".localized, message: "PressOkToContinue".localized)
        }
    }


    /**
     * Callback function that is called when action button is pressed.
     */
    func actionButtonAction(_ sender: UIButton) {
        //
        if let organization = m_organization {
            //
            if organization.id != nil {
                //
                RestApiImpl.shared.updateOrganization(organization, completion: updateOrganizationCallback(_:))
            } else {
                //
                RestApiImpl.shared.createOrganization(organization, completion: createOrganizationCallback(_:))
            }
        }
    }

}
