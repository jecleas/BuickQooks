import PhotosUI
import SwiftUI

struct TemplateEditorView: View {
    let container: AppContainer
    @StateObject private var viewModel: TemplateSettingsViewModel
    @State private var selectedItem: PhotosPickerItem?

    init(container: AppContainer) {
        self.container = container
        _viewModel = StateObject(wrappedValue: TemplateSettingsViewModel(repository: container.templateRepository))
    }

    var body: some View {
        Form {
            Section("Branding") {
                if let data = viewModel.settings.logoImageData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                } else {
                    Text("No logo set")
                        .foregroundStyle(.secondary)
                }
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Label("Choose Logo", systemImage: "photo")
                }
            }

            Section("Company Info") {
                TextField("Company Name", text: $viewModel.settings.companyName)
                TextField("Email", text: Binding($viewModel.settings.companyEmail, replacingNilWith: ""))
                TextField("Address", text: Binding($viewModel.settings.companyAddress, replacingNilWith: ""))
            }

            Section("Footer") {
                TextEditor(text: $viewModel.settings.footerText)
                    .frame(minHeight: 80)
            }
        }
        .navigationTitle("Template Editor")
        .toolbar {
            Button("Save") { viewModel.save() }
        }
        .onChange(of: selectedItem) { newValue in
            guard let item = newValue else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    await MainActor.run { viewModel.settings.logoImageData = data }
                }
            }
        }
    }
}

private extension Binding where Value == String {
    init(_ source: Binding<String?>, replacingNilWith defaultValue: String = "") {
        self = Binding<String>(
            get: { source.wrappedValue ?? defaultValue },
            set: { newValue in
                source.wrappedValue = newValue.isEmpty ? nil : newValue
            }
        )
    }
}
