import Foundation

struct Customer: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var email: String?
    var phone: String?
    var address: String?
}
