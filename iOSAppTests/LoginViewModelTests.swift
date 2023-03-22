import XCTest
import Combine
@testable import iOSApp

class LoginViewModelTests: XCTestCase {
    private var viewModel: LoginViewModel!
    private var mockLoginManager: MockLoginManager!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
       mockLoginManager = MockLoginManager()
       viewModel = LoginViewModel(loginValidator: mockLoginManager)
    }
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        mockLoginManager = nil
        viewModel = nil
        super.tearDown()
    }
    func test_whenBothFieldsAreEmpty() throws {
        viewModel.login = ""
        viewModel.password = ""
        viewModel.isInputValid.sink {
            XCTAssertFalse($0)
        }
        .store(in: &cancellables)
    }
    func test_whenOnlyOneFieldIsEmpty() throws {
        viewModel.login = "login"
        viewModel.password = ""
        viewModel.isInputValid.sink {
            XCTAssertFalse($0)
        }
        .store(in: &cancellables)
    }
    func test_whenBothAreValidFields() throws {
        viewModel.login = "john@gmail.com"
        viewModel.password = "password"
        viewModel.isInputValid.sink {
            XCTAssertTrue($0)
        }
        .store(in: &cancellables)
    }
    func test_validateSuccessCredentials() throws {
        mockLoginManager.validateCredentialsClosure = { completion in
            completion(.success(()))
        }
        viewModel.validationResult.sink(
            receiveCompletion: { _ in
                XCTFail("Value")
            }, receiveValue: { _ in
                return
            })
        .store(in: &cancellables)
        viewModel.validateLogin()
        XCTAssertTrue(mockLoginManager.validateCredentialsCalled)
    }
    func test_validateFailureCredentials() throws {
        mockLoginManager.validateCredentialsClosure = { completion in
            completion(.failure(MockError.error))
        }
        viewModel.validationResult.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Failure")
                case .failure:
                    return
                }
            }, receiveValue: { _ in
                return
            })
        .store(in: &cancellables)
        viewModel.validateLogin()
        XCTAssertTrue(mockLoginManager.validateCredentialsCalled)
    }
}

// MARK: - Mock Error

enum MockError: Error {
    case error
}
