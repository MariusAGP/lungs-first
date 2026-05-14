import SwiftUI

struct ActiveChallengeRow: View {
    let userChallenge: UserChallenge
    let currentStreak: Int
    let totalCheckIns: Int
    let settings: UserSettings?

    private var progress: (current: Double, target: Double) {
        ProgressCalculator.progress(for: userChallenge, currentStreak: currentStreak, totalCheckIns: totalCheckIns, settings: settings)
    }

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: userChallenge.challenge?.iconName ?? "flag.fill")
                .font(.title2)
                .foregroundStyle(Color.primaryGreen)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 6) {
                Text(userChallenge.challenge?.title ?? "Challenge")
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                ProgressView(value: ProgressCalculator.fraction(progress))
                    .tint(Color.primaryGreen)
                Text(progressLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 6)
    }

    private var progressLabel: String {
        let unit = userChallenge.challenge?.unit ?? ""
        let current = formatValue(progress.current)
        let target = formatValue(progress.target)
        return "\(current) / \(target) \(unit)"
    }

    private func formatValue(_ v: Double) -> String {
        if v.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(v))"
        }
        return String(format: "%.2f", v)
    }
}
