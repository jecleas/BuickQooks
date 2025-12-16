import SwiftUI

@main
struct BuickQooksApp: App {
    @StateObject private var environment = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            ContentView(container: environment.container)
        }
    }
}
