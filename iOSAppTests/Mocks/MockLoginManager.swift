import Foundation
@testable import iOSApp

final class MockLoginManager: LoginValidatorProtocol {
    // MARK: - Validate Login details
    var validateCredentialsCalled = false
    var validateCredentialsClosure: ((@escaping (Result<(), Error>) -> Void) -> Void)?
    func validateCredentials(
        login: String,
        password: String,
        completion: @escaping (Result<(), Error>) -> Void
    ) {
        validateCredentialsCalled = true
        validateCredentialsClosure?(completion)
    }
}
