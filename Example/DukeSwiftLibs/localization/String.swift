import Foundation

/**
 * String extension to help out with getting localized resources.
 *
 * Example usage:
 * nameLabel.text = "Test".localized
 */
extension String {

    var localized: String {
        //
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

}