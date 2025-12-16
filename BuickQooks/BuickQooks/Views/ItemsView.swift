import SwiftUI

struct ItemsView: View {
    let container: AppContainer
    @StateObject private var viewModel: ItemsViewModel
    @State private var showingForm = false
    @State private var draftName = ""
    @State private var draftPrice = ""
    @State private var draftDescription = ""

    init(container: AppContainer) {
        self.container = container
        _viewModel = StateObject(wrappedValue: ItemsViewModel(repository: container.itemRepository))
    }

    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                VStack(alignment: .leading) {
                    Text(item.name).font(.headline)
                    Text("$\(NSDecimalNumber(decimal: item.unitPrice).doubleValue, specifier: "%.2f")")
                    if let desc = item.description, !desc.isEmpty {
                        Text(desc).foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete(perform: viewModel.delete)
        }
        .navigationTitle("Items")
        .toolbar {
            Button { showingForm = true } label: { Image(systemName: "plus") }
        }
        .sheet(isPresented: $showingForm) {
            NavigationStack {
                Form {
                    TextField("Name", text: $draftName)
                    TextField("Unit Price", text: $draftPrice)
                        .keyboardType(.decimalPad)
                    TextField("Description", text: $draftDescription)
                }
                .navigationTitle("Add Item")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showingForm = false } }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let price = Decimal(string: draftPrice) ?? 0
                            viewModel.add(name: draftName, price: price, description: draftDescription.isEmpty ? nil : draftDescription)
                            resetForm()
                        }
                        .disabled(draftName.isEmpty)
                    }
                }
            }
        }
    }

    private func resetForm() {
        draftName = ""
        draftPrice = ""
        draftDescription = ""
        showingForm = false
    }
}
