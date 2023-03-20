import UIKit

struct AlertManager {
    static func showAlert(forMessage: String,
                          title: String,
                          defaultButtonTitle: String,
                          sourceViewController: UIViewController) {
        let alertController = UIAlertController(title: title,
                                                message: forMessage,
                                                preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultButtonTitle,
                                          style: .default)
        alertController.addAction(defaultAction)
        sourceViewController.present(alertController,
                                     animated: true,
                                     completion: nil)
    }
}
