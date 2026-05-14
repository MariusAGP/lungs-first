import SwiftUI
import SwiftData

struct RootView: View {
    @Query private var allSettings: [UserSettings]

    private var needsOnboarding: Bool {
        guard let settings = allSettings.first else { return true }
        return !settings.hasCompletedOnboarding
    }

    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Dashboard", systemImage: "house.fill") }

            ChallengeListView()
                .tabItem { Label("Challenges", systemImage: "list.bullet.rectangle.fill") }

            AchievementsView()
                .tabItem { Label("Achievements", systemImage: "star.fill") }
        }
        .tint(Color.primaryGreen)
        .sheet(isPresented: .constant(needsOnboarding)) {
            OnboardingView()
        }
    }
}
