import SwiftUI

struct StatisticsSection: View {
    let totalSmokeFreeDays: Int
    let totalMoneySaved: Double
    let completedChallenges: Int

    private var moneyString: String {
        totalMoneySaved.formatted(.currency(code: "EUR"))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Statistics")
                .font(.headline)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                StatRow(
                    iconName: "calendar",
                    title: "Total smoke-free days",
                    value: "\(totalSmokeFreeDays)"
                )
                Divider().padding(.leading, 50)
                StatRow(
                    iconName: "eurosign.circle.fill",
                    title: "Total money saved",
                    value: moneyString
                )
                Divider().padding(.leading, 50)
                StatRow(
                    iconName: "checkmark.seal.fill",
                    title: "Challenges completed",
                    value: "\(completedChallenges)"
                )
            }
            .cardStyle()
        }
    }
}

private struct StatRow: View {
    let iconName: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(Color.primaryGreen)
                .frame(width: 36)
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.semibold))
        }
        .padding(.vertical, 10)
    }
}
