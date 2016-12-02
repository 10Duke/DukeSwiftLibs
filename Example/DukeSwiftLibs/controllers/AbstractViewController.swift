import Foundation
import UIKit


/**
 * Abstract controller base class.
 *
 * Contains generic helper functions for creating UI components and related variables.
 */
class AbstractViewController: UIViewController {

    /**
     * Starting y-axis position for component rendering.
     */
    var ypos = 0;

    /**
     * Generic x-axis padding.
     */
    let xpadding = 20;

    /**
     * Generic component height.
     */
    let componentHeight = 50


    /**
     * Creates an image for the UI.
     *
     * - parameter imageName: Name of the image resource to be used.
     * - returns: UIView that contains the image.
     */
    func createImage(imageName: String) -> UIView {
        //
        ypos += componentHeight
        let width = Int(UIScreen.main.bounds.size.width)
        //
        let view = UIView(frame: CGRect(x: 0, y: ypos, width: width, height: componentHeight))
        //
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: componentHeight)
        //
        view.addSubview(imageView)
        //
        return view
    }


    /**
     * Creates a label for the UI.
     *
     * - parameter title: Label title String.
     * - returns: UIView that contains the UILabel.
     */
    func createLabel(title: String) -> UIView {
        //
        ypos += componentHeight
        let screenWidth = UIScreen.main.bounds.size.width
        let width: Int = Int(screenWidth)
        //
        let view = UIView(frame: CGRect(x: 0, y: ypos, width: width, height: componentHeight))
        view.autoresizingMask = UIViewAutoresizing.flexibleRightMargin
        //
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: width, height: componentHeight)
        label.autoresizingMask = UIViewAutoresizing.flexibleRightMargin
        label.text = title
        label.textAlignment = NSTextAlignment.center
        //
        view.addSubview(label)
        //
        return view
    }


    /**
     * Creates a button for the UI with label and input box.
     *
     * - parameter title: Label title String.
     * - parameter value: Current value for the input as String.
     * - parameter action: Callback function that is triggered when the text input is being edited.
     * - parameter editable: Boolean flag to control whether or not the input is editable.
     * - returns: UIView that contains both the label and input components.
     */
    func createInputField(title: String, value: String?, action: Selector?, editable: Bool) -> UIView {
        //
        ypos += componentHeight
        let screenWidth = UIScreen.main.bounds.size.width
        let width: Int = Int(screenWidth)
        //
        let view = UIView(frame: CGRect(x: 0, y: ypos, width: width, height: componentHeight))
        view.autoresizingMask = UIViewAutoresizing.flexibleRightMargin
        //
        let label = UILabel()
        label.frame = CGRect(x: xpadding, y: 0, width: width / 3 - xpadding, height: componentHeight)
        label.text = title
        label.adjustsFontSizeToFitWidth = true
        //
        let input = UITextField()
        input.frame = CGRect(x: width / 3 + xpadding, y: 10, width: width / 3 * 2 - 2 * xpadding, height: 40)
        if editable {
            input.borderStyle = UITextBorderStyle.roundedRect
        }
        input.autoresizingMask = UIViewAutoresizing.flexibleRightMargin
        input.isEnabled = editable
        input.adjustsFontSizeToFitWidth = true
        input.autocorrectionType = UITextAutocorrectionType.no
        if value != nil {
            input.text = value
        }
        if action != nil {
            input.addTarget(self, action: action!, for: UIControlEvents.editingChanged)
        }
        //
        view.addSubview(label)
        view.addSubview(input)
        //
        return view
    }


    /**
     * Creates action button for UI.
     *
     * - parameter title: Label title String.
     * - parameter action: Callback function that is triggered when the button is clicked.
     * - parameter enabled: Boolean flag to control if the button is active.
     * - returns: UIView that contains both the action button.
     */
    func createActionButton(title: String, action: Selector, enabled: Bool) -> UIView {
        //
        ypos += componentHeight
        let screenWidth = UIScreen.main.bounds.size.width
        let width: Int = Int(screenWidth)
        //
        let view = UIView(frame: CGRect(x: 0, y: ypos, width: width, height: componentHeight))
        view.autoresizingMask = UIViewAutoresizing.flexibleRightMargin
        //
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: width, height: componentHeight)
        button.setTitle(title, for: UIControlState.normal)
        button.setTitleColor(self.view.tintColor, for: UIControlState.normal)
        button.setTitleColor(UIColor.gray, for: UIControlState.disabled)
        button.addTarget(self, action: action, for: UIControlEvents.touchDown)
        button.isEnabled = enabled
        //
        view.addSubview(button)
        //
        return view
    }


    /**
     * Recalculates UIScrollView maximum height to enable scrolling.
     *
     * - parameter scrollView: The UIScrollView component to be calculated.
     */
    func setMaxHeight(scrollView: UIScrollView) {
        //
        var maxHeight = 0;
        //
        for view in scrollView.subviews {
            //
            let childHeight = Int(view.frame.origin.y + view.frame.size.height);
            //
            if childHeight > maxHeight {
                maxHeight = childHeight;
            }
        }
        //
        scrollView.contentSize.height = CGFloat(maxHeight)
    }


    /**
     * Shows an alert error with title and message on screen with an OK button to continue.
     *
     * - parameter title: The title text of the alert.
     * - parameter message: The message text of the alert.
     */
    func showError(title: String, message: String) {
        //
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        //
        let alertAction = UIAlertAction(title: "Ok".localized, style: UIAlertActionStyle.default, handler: nil)
        //
        alert.addAction(alertAction)
        //
        present(alert, animated: true, completion: nil)
    }
    
}
