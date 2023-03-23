import Foundation
import Combine

protocol UserServiceProtocol {
    func getData(endpoint: String) -> AnyPublisher<[UserModel], Error>
}

final class UserService: UserServiceProtocol {
    private var cancellables = Set<AnyCancellable>()
    
    func getData(endpoint: String) -> AnyPublisher<[UserModel], Error> {
        return Future<[UserModel], Error> { [weak self] promise in
            guard let self = self, let url = URL(string: endpoint) else {
                return promise(.failure(NetworkError.invalidurl))
            }
            print("URL is \(url.absoluteString)")
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~=
                            httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: [UserModel].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknownError))
                        }
                    }
                }, receiveValue: { (output) in
                    promise(.success(output)) })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
}

enum NetworkError: Error {
    case invalidurl
    case responseError
    case unknownError
}
