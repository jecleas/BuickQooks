import SwiftUI

struct DashboardView: View {
    let container: AppContainer
    let headerColor: Color
    @StateObject private var viewModel: DashboardViewModel

    init(container: AppContainer, headerColor: Color) {
        self.container = container
        self.headerColor = headerColor
        _viewModel = StateObject(wrappedValue: DashboardViewModel(repository: container.invoiceRepository))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            actionButtons
            invoiceList
            Spacer()
        }
        .padding()
        .onAppear { viewModel.load() }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image("app")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
            VStack(alignment: .leading) {
                Text("Invoice dashboard")
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }

    private var actionButtons: some View {
        HStack {
            NavigationLink("Create Invoice") {
                InvoiceEditorView(container: container, headerColor: headerColor)
            }
            .buttonStyle(.borderedProminent)
            .tint(headerColor)

            NavigationLink("Items") { ItemsView(container: container) }
                .buttonStyle(.bordered)

            NavigationLink("Customers") { CustomersView(container: container) }
                .buttonStyle(.bordered)

            NavigationLink("Template Editor") { TemplateEditorView(container: container) }
                .buttonStyle(.bordered)

            Spacer()
        }
    }

    private var invoiceList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Invoices")
                .font(.title2.bold())
            if viewModel.invoices.isEmpty {
                Text("No invoices yet. Generate your first one!")
                    .foregroundStyle(.secondary)
            } else {
                List(viewModel.invoices) { invoice in
                    NavigationLink(destination: InvoiceDetailView(invoice: invoice, container: container)) {
                        VStack(alignment: .leading) {
                            Text(invoice.invoiceNumber)
                                .font(.headline)
                            Text(invoice.billTo.name)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .listStyle(.inset)
            }
        }
    }
}
