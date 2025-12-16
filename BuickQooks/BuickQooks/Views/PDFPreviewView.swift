import SwiftUI

struct PDFPreviewView: View {
    let url: URL
    let headerColor: Color
    @State private var showingShare = false

    var body: some View {
        NavigationStack {
            VStack {
                PDFKitView(url: url)
                Button {
                    showingShare = true
                } label: {
                    Label("Share PDF", systemImage: "square.and.arrow.up")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(headerColor.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
            .navigationTitle("PDF Preview")
        }
        .sheet(isPresented: $showingShare) {
            ShareSheet(activityItems: [url])
        }
    }
}
