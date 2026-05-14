import Foundation
import SwiftData

enum SeedData {
    static func seedIfNeeded(context: ModelContext) {
        seedChallengesIfNeeded(context: context)
        seedBadgesIfNeeded(context: context)
        try? context.save()
    }

    private static func seedChallengesIfNeeded(context: ModelContext) {
        let existing = (try? context.fetch(FetchDescriptor<Challenge>())) ?? []
        let existingTitles = Set(existing.map(\.title))

        let seeds: [Challenge] = [
            Challenge(
                title: "First 24 Hours",
                desc: "Make it through your first full day smoke-free. The hardest — and most important — first step.",
                category: .time,
                targetValue: 1,
                unit: "Days",
                difficulty: .easy,
                iconName: "clock.fill"
            ),
            Challenge(
                title: "One Week Strong",
                desc: "Seven days without a cigarette. Your body is already thanking you.",
                category: .time,
                targetValue: 7,
                unit: "Days",
                difficulty: .medium,
                iconName: "calendar"
            ),
            Challenge(
                title: "The Smoke-Free Month",
                desc: "Thirty smoke-free days. The habit is breaking — keep going.",
                category: .time,
                targetValue: 30,
                unit: "Days",
                difficulty: .hard,
                iconName: "calendar.badge.checkmark"
            ),
            Challenge(
                title: "50€ Saved",
                desc: "Track 50€ worth of cigarettes you didn't buy.",
                category: .money,
                targetValue: 50,
                unit: "Euro",
                difficulty: .medium,
                iconName: "eurosign.circle.fill"
            ),
            Challenge(
                title: "100 Cigarettes Avoided",
                desc: "Log 100 cigarettes you chose not to smoke.",
                category: .health,
                targetValue: 100,
                unit: "Cigarettes",
                difficulty: .medium,
                iconName: "lungs.fill"
            ),
            Challenge(
                title: "Smoke-Free with a Friend",
                desc: "Stay smoke-free for 14 days alongside a buddy.",
                category: .social,
                targetValue: 14,
                unit: "Days",
                difficulty: .medium,
                iconName: "person.2.fill"
            ),
            Challenge(
                title: "Taste Buds Are Back",
                desc: "Two days smoke-free — your sense of taste and smell starts returning.",
                category: .health,
                targetValue: 2,
                unit: "Days",
                difficulty: .easy,
                iconName: "mouth.fill"
            ),
            Challenge(
                title: "90-Day Champion",
                desc: "Ninety days. You've changed your life.",
                category: .time,
                targetValue: 90,
                unit: "Days",
                difficulty: .hard,
                iconName: "crown.fill"
            ),
            Challenge(
                title: "100 Push-Ups",
                desc: "Every time a craving hits, drop and do 10 push-ups. Reach 100 total and prove that your body is stronger than the habit.",
                category: .health,
                targetValue: 100,
                unit: "Push-ups",
                difficulty: .medium,
                iconName: "figure.strengthtraining.traditional"
            ),
        ]

        for c in seeds where !existingTitles.contains(c.title) { context.insert(c) }
    }

    private static func seedBadgesIfNeeded(context: ModelContext) {
        let existing = (try? context.fetch(FetchDescriptor<Badge>())) ?? []
        let existingConditions = Set(existing.map(\.condition))

        let seeds: [Badge] = [
            Badge(
                title: "First Step",
                desc: "Accepted your first challenge.",
                iconName: "star.fill",
                condition: "first_challenge"
            ),
            Badge(
                title: "3-Day Streak",
                desc: "Three smoke-free days in a row.",
                iconName: "flame.fill",
                condition: "streak_3"
            ),
            Badge(
                title: "Week Warrior",
                desc: "A full smoke-free week.",
                iconName: "bolt.fill",
                condition: "streak_7"
            ),
            Badge(
                title: "Monthly Champion",
                desc: "Thirty smoke-free days.",
                iconName: "trophy.fill",
                condition: "streak_30"
            ),
            Badge(
                title: "Money Saver",
                desc: "Saved 50€ by not smoking.",
                iconName: "eurosign.circle.fill",
                condition: "money_saved_50"
            ),
            Badge(
                title: "Challenge Master",
                desc: "Completed three challenges.",
                iconName: "medal.fill",
                condition: "challenges_3"
            ),
            Badge(
                title: "Smoke-Free Legend",
                desc: "Ninety smoke-free days.",
                iconName: "crown.fill",
                condition: "streak_90"
            ),
        ]

        for b in seeds where !existingConditions.contains(b.condition) { context.insert(b) }
    }
}
