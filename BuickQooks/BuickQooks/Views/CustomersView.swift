import SwiftUI

struct CustomersView: View {
    let container: AppContainer
    @StateObject private var viewModel: CustomersViewModel
    @State private var showingForm = false
    @State private var draftName = ""
    @State private var draftEmail = ""
    @State private var draftPhone = ""
    @State private var draftAddress = ""

    init(container: AppContainer) {
        self.container = container
        _viewModel = StateObject(wrappedValue: CustomersViewModel(repository: container.customerRepository))
    }

    var body: some View {
        List {
            ForEach(viewModel.customers) { customer in
                VStack(alignment: .leading, spacing: 4) {
                    Text(customer.name).font(.headline)
                    if let email = customer.email { Text(email).foregroundStyle(.secondary) }
                    if let phone = customer.phone { Text(phone).foregroundStyle(.secondary) }
                    if let address = customer.address { Text(address).foregroundStyle(.secondary) }
                }
            }
            .onDelete(perform: viewModel.delete)
        }
        .navigationTitle("Customers")
        .toolbar {
            Button { showingForm = true } label: { Image(systemName: "plus") }
        }
        .sheet(isPresented: $showingForm) {
            NavigationStack {
                Form {
                    TextField("Name", text: $draftName)
                    TextField("Email", text: $draftEmail)
                    TextField("Phone", text: $draftPhone)
                    TextField("Address", text: $draftAddress)
                }
                .navigationTitle("Add Customer")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showingForm = false } }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            viewModel.add(name: draftName,
                                          email: draftEmail.isEmpty ? nil : draftEmail,
                                          phone: draftPhone.isEmpty ? nil : draftPhone,
                                          address: draftAddress.isEmpty ? nil : draftAddress)
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
        draftEmail = ""
        draftPhone = ""
        draftAddress = ""
        showingForm = false
    }
}
