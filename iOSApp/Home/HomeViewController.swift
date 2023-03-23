import UIKit
import Combine

final class HomeViewController: UIViewController {
    @IBOutlet private var homeTableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    var isLoading: Bool = false {
        didSet { isLoading ? startLoading() : finishLoading() }
    }
    
    private let viewModel: HomeViewModel
    private let connection: ConnectionStatusProtocol
    private var bindings = Set<AnyCancellable>()
    
    init(viewModel: HomeViewModel = HomeViewModel(),
         connection: ConnectionStatusProtocol = ConnectionStatus()) {
        self.viewModel = viewModel
        self.connection = connection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupView()
        setupBindings()
        view.accessibilityIdentifier = Strings.homeTableViewAccessibility
        homeTableView.accessibilityIdentifier = Strings.homeTableViewAccessibility
    }
    
    private func setupView() {
        let nib = UINib(nibName: Strings.homeTableCellIdentifier, bundle: nil)
        homeTableView.register(nib, forCellReuseIdentifier: Strings.homeTableCellIdentifier)
        if connection.hasConnectivity() {
            viewModel.getData()
        } else {
            AlertManager.showAlert(forMessage: Strings.Network.errorMessage,
                                   title: Strings.Network.errorTitle,
                                   defaultButtonTitle: Strings.loginAlertDefaultBtn,
                                   sourceViewController: self)
        }
    }
    
    func startLoading() {
        self.homeTableView.isUserInteractionEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func finishLoading() {
        self.homeTableView.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func setupBindings() {
        viewModel.$isLoading
            .assign(to: \.isLoading, on: self)
            .store(in: &bindings)
        viewModel.$users
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.homeTableView.reloadData()
            })
            .store(in: &bindings)
        
    }
}

// MARK: - TableView Data Source
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: Strings.homeTableCellIdentifier,
            for: indexPath) as? HomeTableViewCell {
            if !viewModel.users.isEmpty {
                cell.configure(viewModel.users[indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }
}
