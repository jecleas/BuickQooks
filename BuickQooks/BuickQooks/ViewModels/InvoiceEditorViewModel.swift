import Foundation
import SwiftUI
import Combine

final class InvoiceEditorViewModel: ObservableObject {
    @Published var selectedCustomer: Customer?
    @Published var lineItems: [InvoiceLineItem] = []
    @Published var notes: String = ""
    @Published var issueDate: Date = Date()
    @Published var dueDate: Date = Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date()
    @Published var invoiceNumber: String
    @Published var taxRate: Decimal = 0
    @Published var generatedURL: URL?
    @Published var showingShare: Bool = false

    private let itemRepository: ItemRepository
    private let customerRepository: CustomerRepository
    private let invoiceRepository: InvoiceRepository
    private let templateRepository: TemplateSettingsRepository
    private let pdfGenerator: InvoicePDFGenerator
    private let numberFormatter: InvoiceNumberFormatter

    init(itemRepository: ItemRepository,
         customerRepository: CustomerRepository,
         invoiceRepository: InvoiceRepository,
         templateRepository: TemplateSettingsRepository,
         pdfGenerator: InvoicePDFGenerator,
         numberFormatter: InvoiceNumberFormatter) {
        self.itemRepository = itemRepository
        self.customerRepository = customerRepository
        self.invoiceRepository = invoiceRepository
        self.templateRepository = templateRepository
        self.pdfGenerator = pdfGenerator
        self.numberFormatter = numberFormatter
        self.invoiceNumber = numberFormatter.generate()
    }

    var customers: [Customer] { customerRepository.getAll() }
    var items: [Item] { itemRepository.getAll() }

    func addLineItem(from item: Item, quantity: Int) {
        let line = InvoiceLineItem(itemName: item.name, unitPrice: item.unitPrice, quantity: quantity)
        lineItems.append(line)
    }

    func addCustomLineItem(name: String, price: Decimal, quantity: Int) {
        let line = InvoiceLineItem(itemName: name, unitPrice: price, quantity: quantity)
        lineItems.append(line)
    }

    func removeLineItems(at offsets: IndexSet) {
        lineItems.remove(atOffsets: offsets)
    }

    func generateInvoice() -> Invoice? {
        guard let customer = selectedCustomer, !lineItems.isEmpty else { return nil }
        var invoice = Invoice(
            invoiceNumber: invoiceNumber,
            issueDate: issueDate,
            dueDate: dueDate,
            billTo: customer,
            lineItems: lineItems,
            notes: notes,
            taxRate: taxRate,
            pdfData: nil
        )
        if let url = pdfGenerator.generate(invoice: invoice, template: templateRepository.load()),
           let data = try? Data(contentsOf: url) {
            invoice.pdfData = data
            invoiceRepository.add(invoice)
            generatedURL = url
            return invoice
        }
        return nil
    }
}
