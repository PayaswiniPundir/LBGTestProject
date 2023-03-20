import Combine

final class LoginViewModel {
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    let validationResult = PassthroughSubject<Void, Error>()
    
    private(set) lazy var isInputValid = Publishers.CombineLatest($login, $password)
        .map { $0.count > 2 && $1.count > 2 }
        .eraseToAnyPublisher()
    
    private let loginValidator: LoginValidatorProtocol
    
    init(loginValidator: LoginValidatorProtocol = LoginManager()) {
        self.loginValidator = loginValidator
    }
    
    func validateLogin() {
        isLoading = true
        loginValidator.validateCredentials(login: login,
                                           password: password
        ) { [weak self] result in
            self?.isLoading = false
            
            switch result {
            case .success:
                self?.validationResult.send(())
            case .failure(let error):
                self?.validationResult.send(completion: .failure(error))
                
            }
        }
    }
    
}
