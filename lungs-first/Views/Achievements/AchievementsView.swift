import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Query(sort: \DailyCheckIn.date, order: .reverse) private var checkIns: [DailyCheckIn]
    @Query(sort: \Badge.title) private var badges: [Badge]
    @Query private var allSettings: [UserSettings]
    @Query private var userChallenges: [UserChallenge]

    private let columns = [GridItem(.adaptive(minimum: 110), spacing: 12)]

    private var settings: UserSettings? { allSettings.first }

    private var currentStreak: Int {
        StreakCalculator.currentStreak(from: checkIns)
    }

    private var longestStreak: Int {
        StreakCalculator.longestStreak(from: checkIns)
    }

    private var totalMoneySaved: Double {
        guard let s = settings else { return 0 }
        return Double(checkIns.count) * Double(s.dailyConsumption) * s.pricePerCigarette
    }

    private var completedCount: Int {
        userChallenges.filter { $0.isCompleted }.count
    }

    private var sortedBadges: [Badge] {
        badges.sorted { lhs, rhs in
            if lhs.isUnlocked != rhs.isUnlocked { return lhs.isUnlocked && !rhs.isUnlocked }
            return lhs.title < rhs.title
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    StreakHeroView(streak: currentStreak)

                    if longestStreak > currentStreak {
                        HStack {
                            Image(systemName: "trophy.fill")
                                .foregroundStyle(Color.streakOrange)
                            Text("Longest streak: \(longestStreak) days")
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                        }
                        .cardStyle()
                    }

                    badgeGallery

                    StatisticsSection(
                        totalSmokeFreeDays: checkIns.count,
                        totalMoneySaved: totalMoneySaved,
                        completedChallenges: completedCount
                    )
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .navigationTitle("Achievements")
        }
    }

    private var badgeGallery: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Badges")
                    .font(.headline)
                Spacer()
                let unlocked = badges.filter(\.isUnlocked).count
                Text("\(unlocked) / \(badges.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(sortedBadges) { badge in
                    BadgeGridItemView(badge: badge)
                        .cardStyle()
                }
            }
        }
    }
}
