import Foundation

enum ChallengeCategory: String, CaseIterable, Codable, Identifiable {
    case time = "Time"
    case health = "Health"
    case money = "Money"
    case social = "Social"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .time: return "clock.fill"
        case .health: return "heart.fill"
        case .money: return "eurosign.circle.fill"
        case .social: return "person.2.fill"
        }
    }
}

enum Difficulty: String, CaseIterable, Codable, Identifiable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var id: String { rawValue }
}
