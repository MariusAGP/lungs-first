import SwiftUI

struct BadgeGridItemView: View {
    let badge: Badge

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(badge.isUnlocked ? Color.primaryGreen.opacity(0.18) : Color.gray.opacity(0.10))
                    .frame(width: 70, height: 70)
                Image(systemName: badge.iconName)
                    .font(.system(size: 32))
                    .foregroundStyle(badge.isUnlocked ? Color.primaryGreen : Color.gray.opacity(0.5))
                    .symbolEffect(.bounce, value: badge.isUnlocked)
            }

            Text(badge.title)
                .font(.caption.weight(.semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(badge.isUnlocked ? .primary : .secondary)

            if badge.isUnlocked, let unlockedAt = badge.unlockedAt {
                Text(unlockedAt, format: .dateTime.month(.abbreviated).day())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } else {
                Text(badge.desc)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}
