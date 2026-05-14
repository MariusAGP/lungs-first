import SwiftUI

struct ChallengeCardView: View {
    let challenge: Challenge
    let isAccepted: Bool
    let isCompleted: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.primaryGreen.opacity(0.15))
                Image(systemName: challenge.iconName)
                    .font(.title2)
                    .foregroundStyle(Color.primaryGreen)
            }
            .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(challenge.title)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                    if isCompleted {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(Color.primaryGreen)
                    } else if isAccepted {
                        Image(systemName: "circle.dashed")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Text(challenge.desc)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                HStack(spacing: 8) {
                    DifficultyBadge(difficulty: challenge.difficultyEnum)
                    Text("\(challenge.targetValue) \(challenge.unit)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

struct DifficultyBadge: View {
    let difficulty: Difficulty

    private var tint: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }

    var body: some View {
        Text(difficulty.rawValue)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(tint)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(tint.opacity(0.15), in: Capsule())
    }
}
