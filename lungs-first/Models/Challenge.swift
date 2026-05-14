import Foundation
import SwiftData

@Model
final class Challenge {
    @Attribute(.unique) var id: UUID
    var title: String
    var desc: String // description would break
    var category: String
    var targetValue: Int
    var unit: String
    var difficulty: String
    var iconName: String

    @Relationship(deleteRule: .cascade, inverse: \UserChallenge.challenge)
    var enrollments: [UserChallenge] = []

    init(
        id: UUID = UUID(),
        title: String,
        desc: String,
        category: ChallengeCategory,
        targetValue: Int,
        unit: String,
        difficulty: Difficulty,
        iconName: String
    ) {
        self.id = id
        self.title = title
        self.desc = desc
        self.category = category.rawValue
        self.targetValue = targetValue
        self.unit = unit
        self.difficulty = difficulty.rawValue
        self.iconName = iconName
    }

    var categoryEnum: ChallengeCategory {
        ChallengeCategory(rawValue: category) ?? .time
    }

    var difficultyEnum: Difficulty {
        Difficulty(rawValue: difficulty) ?? .easy
    }
}
