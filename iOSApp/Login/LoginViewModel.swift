import Combine

final class LoginViewModel: ObservableObject {
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    let validationResult = PassthroughSubject<Void, Error>()
    
    private var isValidUsernamePublisher: AnyPublisher<Bool, Never> {
        $login
            .map { $0.isValidEmail }
            .eraseToAnyPublisher()
    }
    
    private var isValidPasswordPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private(set) lazy var isInputValid = Publishers.CombineLatest(isValidUsernamePublisher, isValidPasswordPublisher)
        .map { $0 && $1 }
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
