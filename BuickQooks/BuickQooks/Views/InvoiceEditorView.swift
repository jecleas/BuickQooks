import SwiftUI

struct InvoiceEditorView: View {
    let container: AppContainer
    let headerColor: Color
    @StateObject private var viewModel: InvoiceEditorViewModel
    @State private var selectedItemIndex: Int = 0
    @State private var quantity: Int = 1
    @State private var customName: String = ""
    @State private var customPrice: String = ""
    @State private var showPreview = false

    init(container: AppContainer, headerColor: Color) {
        self.container = container
        self.headerColor = headerColor
        _viewModel = StateObject(wrappedValue: InvoiceEditorViewModel(
            itemRepository: container.itemRepository,
            customerRepository: container.customerRepository,
            invoiceRepository: container.invoiceRepository,
            templateRepository: container.templateRepository,
            pdfGenerator: container.pdfGenerator,
            numberFormatter: container.invoiceNumberFormatter
        ))
    }

    var body: some View {
        Form {
            Section("Customer") {
                Picker("Bill To", selection: Binding(
                    get: { viewModel.selectedCustomer ?? viewModel.customers.first },
                    set: { viewModel.selectedCustomer = $0 }
                )) {
                    ForEach(viewModel.customers) { customer in
                        Text(customer.name).tag(Optional(customer))
                    }
                }
            }

            Section("Invoice Info") {
                TextField("Invoice Number", text: $viewModel.invoiceNumber)
                DatePicker("Issue Date", selection: $viewModel.issueDate, displayedComponents: .date)
                DatePicker("Due Date", selection: $viewModel.dueDate, displayedComponents: .date)
                TextField("Tax Rate (e.g. 0.07)", value: $viewModel.taxRate, format: .number)
                    .keyboardType(.decimalPad)
                TextField("Notes", text: $viewModel.notes, axis: .vertical)
            }

            Section("Add Line Item") {
                Picker("Saved Item", selection: $selectedItemIndex) {
                    ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, item in
                        Text(item.name).tag(index)
                    }
                }
                Stepper(value: $quantity, in: 1...50) {
                    Text("Quantity: \(quantity)")
                }
                Button("Add from Items") {
                    guard viewModel.items.indices.contains(selectedItemIndex) else { return }
                    viewModel.addLineItem(from: viewModel.items[selectedItemIndex], quantity: quantity)
                }
                Divider()
                TextField("Custom Name", text: $customName)
                TextField("Custom Price", text: $customPrice)
                    .keyboardType(.decimalPad)
                Stepper(value: $quantity, in: 1...50) {
                    Text("Quantity: \(quantity)")
                }
                Button("Add Custom") {
                    let price = Decimal(string: customPrice) ?? 0
                    viewModel.addCustomLineItem(name: customName, price: price, quantity: quantity)
                    customName = ""
                    customPrice = ""
                }
            }

            Section("Line Items") {
                if viewModel.lineItems.isEmpty {
                    Text("No line items yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.lineItems) { line in
                        HStack {
                            Text(line.itemName)
                            Spacer()
                            Text("Qty \(line.quantity)")
                        }
                    }
                    .onDelete(perform: viewModel.removeLineItems)
                }
            }

            Button {
                if viewModel.generateInvoice() != nil {
                    showPreview = true
                }
            } label: {
                Text("Generate PDF")
                    .frame(maxWidth: .infinity)
            }
            .disabled(viewModel.selectedCustomer == nil || viewModel.lineItems.isEmpty)
        }
        .navigationTitle("Create Invoice")
        .sheet(isPresented: $showPreview) {
            if let url = viewModel.generatedURL {
                PDFPreviewView(url: url, headerColor: headerColor)
            }
        }
    }
}
