import Foundation

final class AppEnvironment: ObservableObject {
    let container: AppContainer

    init(container: AppContainer = .withInMemoryDefaults()) {
        self.container = container
    }
}
