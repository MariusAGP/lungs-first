import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DailyCheckIn.date, order: .reverse) private var checkIns: [DailyCheckIn]
    @Query(filter: #Predicate<UserChallenge> { $0.isActive && !$0.isCompleted })
    private var activeChallenges: [UserChallenge]
    @Query private var allSettings: [UserSettings]

    @State private var showingCheckInConfirmation = false

    private var settings: UserSettings? { allSettings.first }

    private var currentStreak: Int {
        StreakCalculator.currentStreak(from: checkIns)
    }

    private var hasCheckedInToday: Bool {
        StreakCalculator.hasCheckedInToday(checkIns)
    }

    private var cigarettesAvoided: Int {
        guard let s = settings else { return 0 }
        return checkIns.count * s.dailyConsumption
    }

    private var moneySaved: Double {
        guard let s = settings else { return 0 }
        return Double(cigarettesAvoided) * s.pricePerCigarette
    }

    private var moneySavedString: String {
        moneySaved.formatted(.currency(code: "EUR"))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    StreakHeroView(streak: currentStreak)

                    motivationBanner

                    checkInButton

                    statsGrid

                    HealthRecoveryCard(daysSmokeFree: Double(checkIns.count))

                    activeChallengesSection
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .navigationTitle("Dashboard")
            .background(Color(.systemBackground))
        }
    }

    private var motivationBanner: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "quote.bubble.fill")
                .foregroundStyle(Color.primaryGreen)
                .font(.title3)
            Text(MotivationService.message(for: currentStreak))
                .font(.callout)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .cardStyle()
    }

    private var checkInButton: some View {
        Button(action: checkInToday) {
            HStack {
                Image(systemName: hasCheckedInToday ? "checkmark.circle.fill" : "lungs.fill")
                Text(hasCheckedInToday ? "Today is logged — well done!" : "Mark today smoke-free")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.borderedProminent)
        .tint(hasCheckedInToday ? Color.gray : Color.primaryGreen)
        .disabled(hasCheckedInToday)
    }

    private var statsGrid: some View {
        HStack(spacing: 12) {
            StatCardView(
                iconName: "smoke.fill",
                title: "Cigarettes avoided",
                value: "\(cigarettesAvoided)",
                tint: Color.primaryGreen
            )
            StatCardView(
                iconName: "eurosign.circle.fill",
                title: "Money saved",
                value: moneySavedString,
                tint: Color.streakOrange
            )
        }
    }

    @ViewBuilder
    private var activeChallengesSection: some View {
        if activeChallenges.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "flag.checkered")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text("No active challenges")
                    .font(.subheadline.weight(.semibold))
                Text("Browse the Challenges tab to accept your first one.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .cardStyle()
        } else {
            VStack(alignment: .leading, spacing: 8) {
                Text("Active Challenges")
                    .font(.headline)
                    .padding(.horizontal, 4)
                VStack(spacing: 0) {
                    ForEach(Array(activeChallenges.enumerated()), id: \.element.id) { idx, uc in
                        NavigationLink(value: uc) {
                            ActiveChallengeRow(userChallenge: uc, currentStreak: currentStreak, totalCheckIns: checkIns.count, settings: settings)
                        }
                        .buttonStyle(.plain)
                        if idx < activeChallenges.count - 1 {
                            Divider().padding(.leading, 50)
                        }
                    }
                }
                .cardStyle()
            }
            .navigationDestination(for: UserChallenge.self) { uc in
                if let challenge = uc.challenge {
                    ChallengeDetailView(challenge: challenge)
                }
            }
        }
    }

    private func checkInToday() {
        guard !hasCheckedInToday else { return }
        let entry = DailyCheckIn(date: .now)
        modelContext.insert(entry)
        try? modelContext.save()
        BadgeService.evaluate(context: modelContext)
        try? modelContext.save()
        showingCheckInConfirmation = true
    }
}
