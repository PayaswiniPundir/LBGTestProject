import XCTest
import Combine
@testable import iOSApp

final class HomeViewModelTests: XCTestCase {
    private var subject: HomeViewModel!
    private var mockUserService: MockUserService!
    private var cancellables: Set<AnyCancellable> = []
    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        subject = HomeViewModel(userService: mockUserService)
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
        subject.getData()
        XCTAssertEqual(mockUserService.getCallsCount, 1)
    }
    func test_whenServiceIsFailed() {
        mockUserService.getResult = .failure(MockError.error)
        subject.getData()
        subject.$users.sink { XCTAssert($0.isEmpty) }
            .store(in: &cancellables)
    }
}

extension HomeViewModelTests {
    enum Constants {
        static let users = [
            UserModel(id: 0, name: "Jhn", email: "John@gmail.com", phone: "898989898989"),
            UserModel(id: 1, name: "Hanme", email: "Harry@gmail.com", phone: "989898989898")
        ]
    }
}
