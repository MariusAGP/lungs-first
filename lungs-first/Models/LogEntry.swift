import Foundation
import SwiftData

@Model
final class LogEntry {
    @Attribute(.unique) var id: UUID
    var userChallenge: UserChallenge?
    var date: Date
    var value: Double
    var note: String?

    init(
        id: UUID = UUID(),
        userChallenge: UserChallenge? = nil,
        date: Date = .now,
        value: Double,
        note: String? = nil
    ) {
        self.id = id
        self.userChallenge = userChallenge
        self.date = date
        self.value = value
        self.note = note
    }
}
