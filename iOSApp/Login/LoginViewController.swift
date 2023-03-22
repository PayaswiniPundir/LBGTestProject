import UIKit
import Combine

class LoginViewController: UIViewController {
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var contentView: UIView!
    @IBOutlet var signInButton: UIButton!
    
    private let viewModel: LoginViewModel
    private var bindings = Set<AnyCancellable>()
    
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupView()
        setupBindings()
    }
    
    private func setupView() {
        emailTextField.backgroundColor = .systemBackground
        emailTextField.placeholder = Strings.emailPlaceholder
        passwordTextField.backgroundColor = .systemBackground
        passwordTextField.placeholder = Strings.passwordPlaceholder
        contentView.backgroundColor = .stackBackground
        contentView.layer.cornerRadius = 10
        signInButton.setTitle(Strings.signInButtonTitle, for: UIControl.State())
        signInButton.setTitleColor(.white, for: UIControl.State())
        signInButton.backgroundColor = .valid
        signInButton.layer.cornerRadius = 10
    }
    
    private func setupBindings() {
        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.login, on: viewModel)
            .store(in: &bindings)
        passwordTextField.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &bindings)
        viewModel.isInputValid
                .assign(to: \.isValid, on: signInButton)
                .store(in: &bindings)
        viewModel.validationResult.sink { completion in
            switch completion {
            case .finished:
                return
            case .failure:
                return
            }
        } receiveValue: { [weak self] in
            self?.navigateToHome()
        }
        .store(in: &bindings)
    }
    
    @IBAction private func signInButtonTap(_sender: AnyObject) {
            viewModel.validateLogin()
    }
    
    private func navigateToHome() {
        let homeViewController = HomeViewController()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}
