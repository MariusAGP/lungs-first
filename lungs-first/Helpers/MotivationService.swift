import Foundation

enum MotivationService {
    static func message(for streak: Int) -> String {
        switch streak {
        case 0:
            return "Every journey begins with a single step. Today is yours."
        case 1:
            return "The first day is the most important one. You chose it — that counts!"
        case 2...3:
            return "The first days are the toughest. Every hour matters!"
        case 4...7:
            return "Your body is starting to recover. Keep going!"
        case 8...14:
            return "Two weeks! The habit is shifting."
        case 15...30:
            return "You're on the right track. The addiction is losing its grip."
        default:
            return "A whole month and beyond! You're an inspiration."
        }
    }

    static let relapseMessage =
        "Setbacks are part of the journey — start fresh! Every new attempt makes you stronger."
}
