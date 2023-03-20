import Combine
import Foundation

final class HomeViewModel {
    private var cancellables = Set<AnyCancellable>()
    @Published var isLoading = false
    @Published var users: [UserModel] = []
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func getData() {
        isLoading = true
        userService.getData(endpoint: Strings.ApiEndPoints.userApi)
            .sink { completion in
                switch completion {
                case .failure(let error):
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
