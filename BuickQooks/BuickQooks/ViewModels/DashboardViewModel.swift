import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    @Published private(set) var invoices: [Invoice] = []
    private let repository: InvoiceRepository

    init(repository: InvoiceRepository) {
        self.repository = repository
        load()
    }

    func load() {
        invoices = repository.getAll().sorted { $0.issueDate > $1.issueDate }
    }
}
