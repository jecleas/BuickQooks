import Foundation
import SwiftUI

final class CustomersViewModel: ObservableObject {
    @Published private(set) var customers: [Customer] = []
    private let repository: CustomerRepository

    init(repository: CustomerRepository) {
        self.repository = repository
        load()
    }

    func load() {
        customers = repository.getAll()
    }

    func add(name: String, email: String?, phone: String?, address: String?) {
        let customer = Customer(name: name, email: email, phone: phone, address: address)
        repository.add(customer)
        load()
    }

    func update(_ customer: Customer) {
        repository.update(customer)
        load()
    }

    func delete(at offsets: IndexSet) {
        for index in offsets { repository.delete(id: customers[index].id) }
        load()
    }
}
