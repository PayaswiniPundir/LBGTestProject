import UIKit

extension UIButton {
    var isValid: Bool {
        get { isEnabled && backgroundColor == .valid }
        set {
            backgroundColor = newValue ? .valid: .invalid
            isEnabled = newValue
        }
    }
}
