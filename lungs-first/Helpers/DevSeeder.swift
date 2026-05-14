#if DEBUG
import Foundation
import SwiftData

// Reads launch environment variables set in the Xcode scheme
// and seeds SwiftData with matching test state on app start.
//
// Supported variables:
//   DEV_FULL_RESET=1          — wipe all user data and return to onboarding
//   DEV_SMOKE_FREE_DAYS=<n>   — replace all check-ins with n consecutive days ending today
enum DevSeeder {
    static func applyIfNeeded(context: ModelContext) {
        let env = ProcessInfo.processInfo.environment
        var dirty = false

        if env["DEV_FULL_RESET"] == "1" {
            fullReset(context: context)
            dirty = true
        }

        if let raw = env["DEV_SMOKE_FREE_DAYS"], let days = Int(raw), days >= 0 {
            seedSmokeFree(days: days, context: context)
            dirty = true
        }

        guard dirty else { return }
        try? context.save()
        BadgeService.evaluate(context: context)
        try? context.save()
    }

    private static func fullReset(context: ModelContext) {
        let checkIns = (try? context.fetch(FetchDescriptor<DailyCheckIn>())) ?? []
        for c in checkIns { context.delete(c) }

        // Deleting UserChallenges cascades to their LogEntries
        let challenges = (try? context.fetch(FetchDescriptor<UserChallenge>())) ?? []
        for c in challenges { context.delete(c) }

        let badges = (try? context.fetch(FetchDescriptor<Badge>())) ?? []
        for b in badges { b.isUnlocked = false; b.unlockedAt = nil }

        let settings = (try? context.fetch(FetchDescriptor<UserSettings>())) ?? []
        for s in settings { s.hasCompletedOnboarding = false }
    }

    private static func seedSmokeFree(days: Int, context: ModelContext) {
        let existing = (try? context.fetch(FetchDescriptor<DailyCheckIn>())) ?? []
        for c in existing { context.delete(c) }

        let cal = Calendar.current
        let today = cal.startOfDay(for: .now)

        for offset in 0..<days {
            guard let date = cal.date(byAdding: .day, value: -offset, to: today) else { continue }
            context.insert(DailyCheckIn(date: date))
        }

        // Ensure onboarding is marked done so the dashboard is shown immediately
        let settingsList = (try? context.fetch(FetchDescriptor<UserSettings>())) ?? []
        if let s = settingsList.first {
            s.hasCompletedOnboarding = true
            if days > 0, let quitDate = cal.date(byAdding: .day, value: -(days - 1), to: today) {
                s.quitDate = quitDate
            }
        }
    }
}
#endif
