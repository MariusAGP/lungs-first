import SwiftUI
import SwiftData

struct ChallengeListView: View {
    @Query(sort: \Challenge.targetValue) private var allChallenges: [Challenge]
    @Query private var userChallenges: [UserChallenge]

    @State private var selectedCategory: ChallengeCategory? = nil

    private var filteredChallenges: [Challenge] {
        guard let category = selectedCategory else { return allChallenges }
        return allChallenges.filter { $0.categoryEnum == category }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                categoryChips
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                List {
                    ForEach(filteredChallenges) { challenge in
                        let uc = userChallenge(for: challenge)
                        NavigationLink(value: challenge) {
                            ChallengeCardView(
                                challenge: challenge,
                                isAccepted: uc != nil,
                                isCompleted: uc?.isCompleted ?? false
                            )
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Challenges")
            .navigationDestination(for: Challenge.self) { challenge in
                ChallengeDetailView(challenge: challenge)
            }
        }
    }

    private func userChallenge(for challenge: Challenge) -> UserChallenge? {
        userChallenges.first { $0.challenge?.id == challenge.id }
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryChip(
                    label: "All",
                    iconName: "square.grid.2x2.fill",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                ForEach(ChallengeCategory.allCases) { category in
                    CategoryChip(
                        label: category.rawValue,
                        iconName: category.iconName,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
}

private struct CategoryChip: View {
    let label: String
    let iconName: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: iconName)
                    .font(.caption)
                Text(label)
                    .font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                isSelected ? Color.primaryGreen : Color.cardBackground,
                in: Capsule()
            )
            .foregroundStyle(isSelected ? Color.white : Color.primary)
        }
        .buttonStyle(.plain)
    }
}
