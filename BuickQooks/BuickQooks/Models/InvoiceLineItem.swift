import Foundation

struct InvoiceLineItem: Identifiable, Equatable {
    var id: UUID = UUID()
    var itemName: String
    var unitPrice: Decimal
    var quantity: Int

    var lineTotal: Decimal {
        Decimal(quantity) * unitPrice
    }
}
