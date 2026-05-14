import Foundation

enum StreakCalculator {
    // Returns 0 if the user hasn't checked in today
    static func currentStreak(from checkIns: [DailyCheckIn], today: Date = .now) -> Int {
        guard !checkIns.isEmpty else { return 0 }
        let calendar = Calendar.current
        let normalizedDays = Set(checkIns.map { calendar.startOfDay(for: $0.date) })
        let startToday = calendar.startOfDay(for: today)

        guard normalizedDays.contains(startToday) else { return 0 }

        var streak = 0
        var cursor = startToday
        while normalizedDays.contains(cursor) {
            streak += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = prev
        }
        return streak
    }

    static func longestStreak(from checkIns: [DailyCheckIn]) -> Int {
        guard !checkIns.isEmpty else { return 0 }
        let calendar = Calendar.current
        let sorted = checkIns
            .map { calendar.startOfDay(for: $0.date) }
            .sorted()

        var longest = 1
        var current = 1
        for i in 1..<sorted.count {
            let prev = sorted[i - 1]
            let curr = sorted[i]
            if calendar.isDate(curr, inSameDayAs: prev) { continue }
            if let dayAfterPrev = calendar.date(byAdding: .day, value: 1, to: prev),
               calendar.isDate(curr, inSameDayAs: dayAfterPrev) {
                current += 1
                longest = max(longest, current)
            } else {
                current = 1
            }
        }
        return longest
    }

    static func hasCheckedInToday(_ checkIns: [DailyCheckIn], today: Date = .now) -> Bool {
        let calendar = Calendar.current
        let startToday = calendar.startOfDay(for: today)
        return checkIns.contains { calendar.isDate($0.date, inSameDayAs: startToday) }
    }
}
