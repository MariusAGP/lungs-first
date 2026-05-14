import SwiftUI

struct HealthRecoveryCard: View {
    let daysSmokeFree: Double

    private var milestone: HealthMilestone {
        HealthMilestones.current(daysSmokeFree: daysSmokeFree)
    }

    private var nextMilestone: HealthMilestone? {
        HealthMilestones.next(after: daysSmokeFree)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "heart.text.square.fill")
                    .foregroundStyle(Color.primaryGreen)
                Text("Health Recovery")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(milestone.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.primaryGreen)
                Text(milestone.body)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let next = nextMilestone {
                Divider()
                VStack(alignment: .leading, spacing: 2) {
                    Text("Next milestone")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .textCase(.uppercase)
                    Text("\(next.title) — Day \(formatThreshold(next.dayThreshold))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private func formatThreshold(_ value: Double) -> String {
        if value < 1 { return String(format: "%.1f", value) }
        return "\(Int(value))"
    }
}
