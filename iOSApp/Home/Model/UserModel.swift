import Foundation

struct UserModel: Decodable, Hashable {
    let id: Int?
    let name: String?
    let email: String?
    let phone: String?
}
