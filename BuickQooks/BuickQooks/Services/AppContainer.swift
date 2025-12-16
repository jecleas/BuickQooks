import Foundation

final class AppContainer {
    let itemRepository: ItemRepository
    let customerRepository: CustomerRepository
    let invoiceRepository: InvoiceRepository
    let templateRepository: TemplateSettingsRepository
    let pdfGenerator: InvoicePDFGenerator
    let invoiceNumberFormatter: InvoiceNumberFormatter

    init(itemRepository: ItemRepository,
         customerRepository: CustomerRepository,
         invoiceRepository: InvoiceRepository,
         templateRepository: TemplateSettingsRepository,
         pdfGenerator: InvoicePDFGenerator,
         invoiceNumberFormatter: InvoiceNumberFormatter) {
        self.itemRepository = itemRepository
        self.customerRepository = customerRepository
        self.invoiceRepository = invoiceRepository
        self.templateRepository = templateRepository
        self.pdfGenerator = pdfGenerator
        self.invoiceNumberFormatter = invoiceNumberFormatter
    }

    static func withInMemoryDefaults() -> AppContainer {
        let items = [
            Item(name: "Consulting", unitPrice: 150, description: "Hourly consulting"),
            Item(name: "Software License", unitPrice: 499, description: "Annual license"),
            Item(name: "Implementation", unitPrice: 1200, description: "Fixed fee implementation")
        ]
        let customers = [
            Customer(name: "Acme Corp", email: "billing@acme.com", phone: "555-1234", address: "1 Infinite Loop"),
            Customer(name: "Globex", email: "accounts@globex.com", phone: "555-7777", address: "742 Evergreen Terrace")
        ]
        let template = TemplateSettings(
            logoImageData: nil,
            footerText: "Thank you for your business!",
            companyName: "Buick Qooks",
            companyEmail: "team@buickqooks.com",
            companyAddress: "123 Market Street, Springfield"
        )

        let itemRepo = InMemoryItemRepository(seed: items)
        let customerRepo = InMemoryCustomerRepository(seed: customers)
        let invoiceRepo = InMemoryInvoiceRepository()
        let templateRepo = InMemoryTemplateSettingsRepository(defaults: template)
        let formatter = InvoiceNumberFormatter()
        let pdfGenerator = InvoicePDFGenerator()

        return AppContainer(
            itemRepository: itemRepo,
            customerRepository: customerRepo,
            invoiceRepository: invoiceRepo,
            templateRepository: templateRepo,
            pdfGenerator: pdfGenerator,
            invoiceNumberFormatter: formatter
        )
    }
}
