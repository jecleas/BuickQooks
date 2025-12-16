import Foundation
import SwiftUI
import Combine

final class ItemsViewModel: ObservableObject {
    @Published private(set) var items: [Item] = []
    private let repository: ItemRepository

    init(repository: ItemRepository) {
        self.repository = repository
        load()
    }

    func load() {
        items = repository.getAll()
    }

    func add(name: String, price: Decimal, description: String?) {
        let item = Item(name: name, unitPrice: price, description: description)
        repository.add(item)
        load()
    }

    func update(item: Item) {
        repository.update(item)
        load()
    }

    func delete(at offsets: IndexSet) {
        for index in offsets { repository.delete(id: items[index].id) }
        load()
    }
}
