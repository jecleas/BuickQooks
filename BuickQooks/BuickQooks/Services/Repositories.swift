import Foundation

protocol ItemRepository {
    func getAll() -> [Item]
    func add(_ item: Item)
    func update(_ item: Item)
    func delete(id: UUID)
}

protocol CustomerRepository {
    func getAll() -> [Customer]
    func add(_ customer: Customer)
    func update(_ customer: Customer)
    func delete(id: UUID)
}

protocol InvoiceRepository {
    func getAll() -> [Invoice]
    func add(_ invoice: Invoice)
    func update(_ invoice: Invoice)
}

protocol TemplateSettingsRepository {
    func load() -> TemplateSettings
    func save(_ settings: TemplateSettings)
}
