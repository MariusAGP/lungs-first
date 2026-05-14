import Foundation
import SwiftData

enum BadgeService {
    static func evaluate(context: ModelContext) {
        let allBadges = (try? context.fetch(FetchDescriptor<Badge>())) ?? []
        let locked = allBadges.filter { !$0.isUnlocked }
        guard !locked.isEmpty else { return }

        let checkIns = (try? context.fetch(FetchDescriptor<DailyCheckIn>())) ?? []
        let userChallenges = (try? context.fetch(FetchDescriptor<UserChallenge>())) ?? []
        let settingsList = (try? context.fetch(FetchDescriptor<UserSettings>())) ?? []
        let settings = settingsList.first

        let currentStreak = StreakCalculator.currentStreak(from: checkIns)
        let longestStreak = StreakCalculator.longestStreak(from: checkIns)
        let acceptedCount = userChallenges.count
        let completedCount = userChallenges.filter { $0.isCompleted }.count

        let totalCheckIns = checkIns.count
        let totalMoneySaved: Double = {
            guard let settings else { return 0 }
            return Double(totalCheckIns) * Double(settings.dailyConsumption) * settings.pricePerCigarette
        }()

        for badge in locked {
            if shouldUnlock(
                condition: badge.condition,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                acceptedCount: acceptedCount,
                completedCount: completedCount,
                totalMoneySaved: totalMoneySaved
            ) {
                badge.isUnlocked = true
                badge.unlockedAt = .now
            }
        }
    }


    private static func shouldUnlock(
        condition: String,
        currentStreak: Int,
        longestStreak: Int,
        acceptedCount: Int,
        completedCount: Int,
        totalMoneySaved: Double
    ) -> Bool {
        let bestStreak = max(currentStreak, longestStreak)
        switch condition {
        case "first_challenge":
            return acceptedCount >= 1
        case "streak_3":
            return bestStreak >= 3
        case "streak_7":
            return bestStreak >= 7
        case "streak_30":
            return bestStreak >= 30
        case "streak_90":
            return bestStreak >= 90
        case "money_saved_50":
            return totalMoneySaved >= 50
        case "challenges_3":
            return completedCount >= 3
        default:
            return false
        }
    }
}
