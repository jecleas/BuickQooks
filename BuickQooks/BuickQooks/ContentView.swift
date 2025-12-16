import SwiftUI

struct ContentView: View {
    let container: AppContainer

    private let headerColor = Color(red: 0/255, green: 120/255, blue: 72/255)

    var body: some View {
        NavigationStack {
            DashboardView(container: container, headerColor: headerColor)
                .navigationTitle("BuickQooks")
        }
    }
}

#Preview {
    ContentView(container: AppContainer.withInMemoryDefaults())
}
