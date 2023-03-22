import Foundation
import Combine
@testable import iOSApp

final class MockUserService: UserServiceProtocol {
    var getResult: Result<[UserModel], Error> = .success([])
    var getCallsCount: Int = 0
    func getData(endpoint: String) -> AnyPublisher<[UserModel], Error> {
        getCallsCount += 1
        return getResult.publisher.eraseToAnyPublisher()
    }
}
