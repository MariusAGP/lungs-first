import SwiftUI

struct StreakHeroView: View {
    let streak: Int

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "flame.fill")
                .font(.system(size: 56))
                .foregroundStyle(Color.streakOrange)
                .symbolEffect(.bounce, value: streak)

            Text("\(streak)")
                .font(.system(size: 84, weight: .bold, design: .rounded))
                .foregroundStyle(Color.primaryGreen)
                .contentTransition(.numericText(value: Double(streak)))
                .animation(.snappy, value: streak)

            Text(streak == 1 ? "Smoke-Free Day" : "Smoke-Free Days")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.primaryGreen.opacity(0.10))
        )
    }
}
