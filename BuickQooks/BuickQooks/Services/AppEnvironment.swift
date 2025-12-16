import Foundation
import Combine

final class AppEnvironment: ObservableObject {
    let container: AppContainer

    init(container: AppContainer = .withInMemoryDefaults()) {
        self.container = container
    }
}
