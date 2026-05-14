import Foundation
import SwiftData

@Model
final class DailyCheckIn {
    @Attribute(.unique) var id: UUID
    var date: Date

    init(id: UUID = UUID(), date: Date = .now) {
        self.id = id
        self.date = Calendar.current.startOfDay(for: date)
    }
}
