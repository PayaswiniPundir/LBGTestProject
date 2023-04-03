import XCTest
import Combine
@testable import iOSApp

final class UserViewModelTests: XCTestCase {
    private var subject: UserViewModel!
    private var mockUserService: MockUserService!
    private var cancellables: Set<AnyCancellable> = []
    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        subject = UserViewModel(userService: mockUserService)
    }
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        mockUserService = nil
        subject = nil
        super.tearDown()
    }
    func test_whenServiceIsCalled() {
        mockUserService.getResult = .success(Constants.users)
        subject.getUserData()
        XCTAssertEqual(mockUserService.getCallsCount, 1)
    }
    func test_whenServiceIsFailed() {
        mockUserService.getResult = .failure(MockError.error)
        subject.getUserData()
        subject.$users.sink { XCTAssert($0.isEmpty) }
            .store(in: &cancellables)
    }
}

extension UserViewModelTests {
    enum Constants {
        static let users = [
            UserModel(id: 0, name: "Jhn", email: "John@gmail.com", phone: "898989898989"),
            UserModel(id: 1, name: "Hanme", email: "Harry@gmail.com", phone: "989898989898")
        ]
    }
}
