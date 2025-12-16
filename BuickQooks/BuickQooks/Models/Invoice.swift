import Foundation

struct Invoice: Identifiable, Equatable {
    var id: UUID = UUID()
    var invoiceNumber: String
    var issueDate: Date
    var dueDate: Date
    var billTo: Customer
    var lineItems: [InvoiceLineItem]
    var notes: String?
    var taxRate: Decimal = 0
    var pdfData: Data?

    var subtotal: Decimal {
        lineItems.reduce(0) { $0 + $1.lineTotal }
    }

    var taxTotal: Decimal {
        subtotal * taxRate
    }

    var total: Decimal {
        subtotal + taxTotal
    }
}
