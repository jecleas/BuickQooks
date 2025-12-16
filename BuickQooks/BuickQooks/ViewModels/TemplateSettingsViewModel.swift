import Foundation
import SwiftUI

final class TemplateSettingsViewModel: ObservableObject {
    @Published var settings: TemplateSettings
    private let repository: TemplateSettingsRepository

    init(repository: TemplateSettingsRepository) {
        self.repository = repository
        self.settings = repository.load()
    }

    func save() {
        repository.save(settings)
    }
}
