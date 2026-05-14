import Foundation
import SwiftData

@Model
final class UserChallenge {
    @Attribute(.unique) var id: UUID
    var challenge: Challenge?
    var startDate: Date
    var isActive: Bool
    var isCompleted: Bool
    var completedAt: Date?

    @Relationship(deleteRule: .cascade, inverse: \LogEntry.userChallenge)
    var entries: [LogEntry] = []

    init(
        id: UUID = UUID(),
        challenge: Challenge? = nil,
        startDate: Date = .now,
        isActive: Bool = true,
        isCompleted: Bool = false,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.challenge = challenge
        self.startDate = startDate
        self.isActive = isActive
        self.isCompleted = isCompleted
        self.completedAt = completedAt
    }
}
