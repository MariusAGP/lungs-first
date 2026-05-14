import Foundation

struct HealthMilestone: Identifiable {
    let id = UUID()
    let dayThreshold: Double
    let title: String
    let body: String
}

enum HealthMilestones {
    static let all: [HealthMilestone] = [
        HealthMilestone(
            dayThreshold: 0,
            title: "Pulse normalizing",
            body: "Within 20 minutes, your pulse and blood pressure begin to drop back to normal."
        ),
        HealthMilestone(
            dayThreshold: 0.5,
            title: "Carbon monoxide clearing",
            body: "After 12 hours, the carbon monoxide level in your blood returns to normal."
        ),
        HealthMilestone(
            dayThreshold: 1,
            title: "Circulation improving",
            body: "After 24 hours, your risk of a heart attack starts to decrease."
        ),
        HealthMilestone(
            dayThreshold: 2,
            title: "Taste and smell returning",
            body: "Your nerve endings start regrowing — food tastes and smells better."
        ),
        HealthMilestone(
            dayThreshold: 3,
            title: "Breathing easier",
            body: "Bronchial tubes relax and lung capacity begins to increase."
        ),
        HealthMilestone(
            dayThreshold: 14,
            title: "Lungs clearing",
            body: "Circulation has improved and lung function has increased significantly."
        ),
        HealthMilestone(
            dayThreshold: 30,
            title: "Coughing reduced",
            body: "Cilia in your lungs regrow, reducing infection risk."
        ),
        HealthMilestone(
            dayThreshold: 90,
            title: "Heart risk halved",
            body: "Your risk of coronary heart disease is now half that of a smoker."
        ),
    ]

    static func current(daysSmokeFree: Double) -> HealthMilestone {
        all.last { $0.dayThreshold <= daysSmokeFree } ?? all[0]
    }

    static func next(after daysSmokeFree: Double) -> HealthMilestone? {
        all.first { $0.dayThreshold > daysSmokeFree }
    }
}
