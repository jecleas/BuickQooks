import Foundation

final class InMemoryItemRepository: ItemRepository {
    private var items: [Item]

    init(seed: [Item] = []) {
        self.items = seed
    }

    func getAll() -> [Item] { items }

    func add(_ item: Item) {
        items.append(item)
    }

    func update(_ item: Item) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index] = item
    }

    func delete(id: UUID) {
        items.removeAll { $0.id == id }
    }
}

final class InMemoryCustomerRepository: CustomerRepository {
    private var customers: [Customer]

    init(seed: [Customer] = []) {
        self.customers = seed
    }

    func getAll() -> [Customer] { customers }

    func add(_ customer: Customer) {
        customers.append(customer)
    }

    func update(_ customer: Customer) {
        guard let index = customers.firstIndex(where: { $0.id == customer.id }) else { return }
        customers[index] = customer
    }

    func delete(id: UUID) {
        customers.removeAll { $0.id == id }
    }
}

final class InMemoryInvoiceRepository: InvoiceRepository {
    private var invoices: [Invoice]

    init(seed: [Invoice] = []) {
        self.invoices = seed
    }

    func getAll() -> [Invoice] { invoices }

    func add(_ invoice: Invoice) {
        invoices.append(invoice)
    }

    func update(_ invoice: Invoice) {
        guard let index = invoices.firstIndex(where: { $0.id == invoice.id }) else { return }
        invoices[index] = invoice
    }
}

final class InMemoryTemplateSettingsRepository: TemplateSettingsRepository {
    private var settings: TemplateSettings

    init(defaults: TemplateSettings) {
        self.settings = defaults
    }

    func load() -> TemplateSettings { settings }

    func save(_ settings: TemplateSettings) {
        self.settings = settings
    }
}
