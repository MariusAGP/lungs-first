import Foundation

enum ProgressCalculator {
    // Progress is derived from the challenge unit:
    //   "Days"        → current streak
    //   "Cigarettes"  → totalCheckIns × dailyConsumption
    //   "Euro"        → totalCheckIns × dailyConsumption × pricePerCigarette
    //   anything else → sum of manually-logged LogEntry values like push ups
    static func isAutoTracked(_ challenge: Challenge) -> Bool {
        switch challenge.unit.lowercased() {
        case "days", "cigarettes", "euro": return true
        default: return false
        }
    }

    static func progress(
        for userChallenge: UserChallenge,
        currentStreak: Int,
        totalCheckIns: Int = 0,
        settings: UserSettings? = nil
    ) -> (current: Double, target: Double) {
        guard let challenge = userChallenge.challenge else { return (0, 1) }
        let target = Double(challenge.targetValue)

        switch challenge.unit.lowercased() {
        case "days":
            return (Double(currentStreak), target)
        case "cigarettes":
            let avoided = totalCheckIns * (settings?.dailyConsumption ?? 0)
            return (Double(avoided), target)
        case "euro":
            let saved = Double(totalCheckIns) * Double(settings?.dailyConsumption ?? 0) * (settings?.pricePerCigarette ?? 0)
            return (saved, target)
        default:
            let total = userChallenge.entries.reduce(0.0) { $0 + $1.value }
            return (total, target)
        }
    }

    static func fraction(_ progress: (current: Double, target: Double)) -> Double {
        guard progress.target > 0 else { return 0 }
        return min(1.0, max(0.0, progress.current / progress.target))
    }

    static func isComplete(_ progress: (current: Double, target: Double)) -> Bool {
        progress.target > 0 && progress.current >= progress.target
    }
}
