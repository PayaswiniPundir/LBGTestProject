import Combine
import Foundation

final class UserViewModel {
    private var cancellables = Set<AnyCancellable>()
    @Published var isLoading = false
    @Published var users: [UserModel] = []
    private let userService: UserServiceProtocol
    var onErrorHandling: ((Error) -> Void)?
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func getUserData() {
        isLoading = true
        userService.getUserData(endpoint: Strings.ApiEndPoints.userApi)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.onErrorHandling?(error)
                    print("Error is \(error.localizedDescription)")
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] userData in
                self?.isLoading = false
                self?.users = userData
                debugPrint("User Data: \(String(describing: self?.users))")
                
            }
            .store(in: &cancellables)
    }
}
