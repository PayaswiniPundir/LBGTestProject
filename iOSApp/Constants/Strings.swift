import Foundation

struct Strings {
    static let emailPlaceholder = "Email"
    static let passwordPlaceholder = "Password"
    static let signInButtonTitle = "Sign in"
    static let loginAlertMessage = "Enter valid login credentials"
    static let loginAlertTitle = "Empty Fields Alert"
    static let loginAlertDefaultBtn = "Ok"
    static let homeTableCellIdentifier = "UserTableViewCell"
    static let homeTableViewAccessibility = "UserListViewController"
    static let homeTableViewControllerAccessibility = "UserTable"
    
    struct Network {
        static let errorMessage = "Please check your internet connection and try again"
        static let errorTitle = "No internet connection"
    }
    
    struct APIError {
        static let errorTitle = "API failure"
    }
    
    struct ApiEndPoints {
        static let userApi = "https://jsonplaceholder.typicode.com/users"
    }
    
    struct Layout {
        static let cornerRadiusForBtn = 10
    }
}
