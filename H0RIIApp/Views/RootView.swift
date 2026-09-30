import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            ProjectsView()
                .tabItem { Label("Projects", systemImage: "square.grid.2x2.fill") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
        }
        .tint(.white)
    }
}

#Preview {
    RootView()
}
