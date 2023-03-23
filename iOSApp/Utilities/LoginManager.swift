import Foundation

// MARK: - LoginValidatorProtocol
protocol LoginValidatorProtocol {
    func validateCredentials (
        login: String,
        password: String,
        completion: @escaping (Result<(), Error>) -> Void)
}

final class LoginManager: LoginValidatorProtocol {
    func validateCredentials (
        login: String,
        password: String,
        completion: @escaping (Result<(), Error>) -> Void) {
            let time: DispatchTime = .now() + .milliseconds(Int.random(in: 200 ... 1000))
            DispatchQueue.main.asyncAfter(deadline: time) {
                completion(.success(()))
            }
        }
}
