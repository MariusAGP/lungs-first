import Foundation
import SwiftData

@Model
final class Badge {
    @Attribute(.unique) var id: UUID
    var title: String
    var desc: String
    var iconName: String
    var condition: String
    var isUnlocked: Bool
    var unlockedAt: Date?

    init(
        id: UUID = UUID(),
        title: String,
        desc: String,
        iconName: String,
        condition: String,
        isUnlocked: Bool = false,
        unlockedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.desc = desc
        self.iconName = iconName
        self.condition = condition
        self.isUnlocked = isUnlocked
        self.unlockedAt = unlockedAt
    }
}
