import SwiftUI

struct InvoiceDetailView: View {
    let invoice: Invoice
    let container: AppContainer
    @State private var showingShare = false

    var body: some View {
        List {
            Section("Summary") {
                Text(invoice.invoiceNumber)
                Text(invoice.billTo.name)
                Text(invoice.notes ?? "")
            }

            if let data = invoice.pdfData, let url = writeTemp(data: data) {
                Section("PDF") {
                    PDFKitView(url: url)
                        .frame(height: 300)
                    Button("Share") { showingShare = true }
                        .sheet(isPresented: $showingShare) {
                            ShareSheet(activityItems: [url])
                        }
                }
            }
        }
        .navigationTitle("Invoice Detail")
    }

    private func writeTemp(data: Data) -> URL? {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Preview-\(invoice.invoiceNumber).pdf")
        try? data.write(to: url)
        return url
    }
}
