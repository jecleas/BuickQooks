import Foundation

struct Item: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var unitPrice: Decimal
    var description: String?
}
