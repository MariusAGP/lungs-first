import SwiftUI
import SwiftData

struct ChallengeDetailView: View {
    let challenge: Challenge

    @Environment(\.modelContext) private var modelContext
    @Query private var allUserChallenges: [UserChallenge]
    @Query(sort: \DailyCheckIn.date, order: .reverse) private var checkIns: [DailyCheckIn]
    @Query private var allSettings: [UserSettings]

    private var settings: UserSettings? { allSettings.first }

    @State private var showingLogSheet = false

    private var userChallenge: UserChallenge? {
        allUserChallenges.first { $0.challenge?.id == challenge.id }
    }

    private var currentStreak: Int {
        StreakCalculator.currentStreak(from: checkIns)
    }

    private var progress: (current: Double, target: Double)? {
        guard let uc = userChallenge else { return nil }
        return ProgressCalculator.progress(for: uc, currentStreak: currentStreak, totalCheckIns: checkIns.count, settings: settings)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header

                Text(challenge.desc)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                if let userChallenge {
                    progressSection(uc: userChallenge)
                    historySection(uc: userChallenge)
                } else {
                    acceptButton
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(challenge.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingLogSheet) {
            if let uc = userChallenge {
                LogProgressSheet(userChallenge: uc)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.primaryGreen.opacity(0.15))
                    .frame(width: 96, height: 96)
                Image(systemName: challenge.iconName)
                    .font(.system(size: 44))
                    .foregroundStyle(Color.primaryGreen)
            }

            HStack(spacing: 8) {
                DifficultyBadge(difficulty: challenge.difficultyEnum)
                Text("\(challenge.targetValue) \(challenge.unit)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func progressSection(uc: UserChallenge) -> some View {
        let p = ProgressCalculator.progress(for: uc, currentStreak: currentStreak, totalCheckIns: checkIns.count, settings: settings)
        let fraction = ProgressCalculator.fraction(p)
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Progress")
                    .font(.headline)
                Spacer()
                if uc.isCompleted {
                    Label("Completed", systemImage: "checkmark.seal.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.primaryGreen)
                }
            }
            ProgressView(value: fraction)
                .tint(Color.primaryGreen)
            HStack {
                Text(format(p.current))
                    .font(.title3.bold())
                Text("of \(format(p.target)) \(challenge.unit)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if !uc.isCompleted && !ProgressCalculator.isAutoTracked(challenge) {
                Button {
                    showingLogSheet = true
                } label: {
                    Label("Log Progress", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.primaryGreen)
                .padding(.top, 4)
            } else if !uc.isCompleted && ProgressCalculator.isAutoTracked(challenge) {
                Text("Progress is tracked automatically through daily check-ins.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .cardStyle()
        .padding(.horizontal)
    }

    @ViewBuilder
    private func historySection(uc: UserChallenge) -> some View {
        if !uc.entries.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("History")
                    .font(.headline)
                    .padding(.horizontal)

                VStack(spacing: 0) {
                    ForEach(uc.entries.sorted(by: { $0.date > $1.date })) { entry in
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(format(entry.value) + " " + challenge.unit)
                                    .font(.subheadline.weight(.semibold))
                                Spacer()
                                Text(entry.date, format: .dateTime.month(.abbreviated).day())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            if let note = entry.note, !note.isEmpty {
                                Text(note)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                        if entry.id != uc.entries.last?.id {
                            Divider()
                        }
                    }
                }
                .cardStyle()
                .padding(.horizontal)
            }
        }
    }

    private var acceptButton: some View {
        Button(action: accept) {
            Label("Accept Challenge", systemImage: "flag.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
        }
        .buttonStyle(.borderedProminent)
        .tint(Color.primaryGreen)
    }

    private func accept() {
        let uc = UserChallenge(
            challenge: challenge,
            startDate: .now,
            isActive: true
        )
        modelContext.insert(uc)
        try? modelContext.save()
        BadgeService.evaluate(context: modelContext)
        try? modelContext.save()
    }

    private func format(_ v: Double) -> String {
        if v.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(v))"
        }
        return String(format: "%.2f", v)
    }
}
