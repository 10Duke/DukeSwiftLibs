import Foundation
import UIKit
import DukeSwiftLibs


/**
 * View controller class for group creation and editing.
 */
class GroupViewController: AbstractViewController, UITextFieldDelegate {

    var m_group: Group?

    var m_actionButton: UIBarButtonItem?


    /**
     * Generic delegate method called when view is loaded.
     */
    override func viewDidLoad() {
        //
        if m_group == nil {
            //
            m_group = Group()
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
        self.view.addSubview(createInputField(title: "Name".localized, value: m_group?.name, action: #selector(self.nameEdited(_:)), editable: true))
        //
        if m_group?.id != nil {
            //
            self.view.addSubview(createInputField(title: "Id".localized, value: m_group?.id, action: nil, editable: false))
        }
        //
        m_actionButton = UIBarButtonItem(title: m_group?.id != nil ? "Save".localized : "Create".localized, style: .plain, target: self, action: #selector(GroupViewController.actionButtonAction(_:)))
        m_actionButton?.isEnabled = false
        self.navigationItem.rightBarButtonItem = m_actionButton
        //
        setMaxHeight(scrollView: scrollView)
    }


    override func viewWillAppear(_ animated: Bool) {
        //
        if m_group?.id != nil {
            //
            navigationItem.title = "GroupInformation".localized
        } else {
            //
            navigationItem.title = "CreateGroup".localized
        }
        //
        navigationItem.backBarButtonItem?.title = "Back".localized
    }


    override func viewDidAppear(_ animated: Bool) {
        //
    }


    /**
     * Name field editing callback.
     */
    func nameEdited(_ textField: UITextField) {
        //
        m_group?.name = textField.text
        m_actionButton?.isEnabled = true
    }


    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }



    /**
     * Update group action result callback function.
     *
     * - parameter success: Boolean that tells if the operation was successful.
     */
    func updateGroupCallback(_ success: Bool) {
        //
        if success {
            //
            m_actionButton?.isEnabled = false
        } else {
            //
            showError(title: "GroupUpdateFailed".localized, message: "PressOkToContinue".localized)
        }
    }


    /**
     * Create group action result callback function.
     *
     * - parameter success: Boolean that tells if the operation was successful.
     */
    func createGroupCallback(_ success: Bool) {
        //
        if success {
            //
            m_actionButton?.isEnabled = false
        } else {
            //
            showError(title: "GroupCreateFailed".localized, message: "PressOkToContinue".localized)
        }
    }


    /**
     * Callback function that is called when action button is pressed.
     */
    func actionButtonAction(_ sender: UIButton) {
        //
        if let group = m_group {
            if group.id != nil {
                //
                RestApiImpl.shared.updateGroup(group, completion: updateGroupCallback(_:))
            } else {
                //
                RestApiImpl.shared.createGroup(group, completion: createGroupCallback(_:))
            }
        }
    }

}
