import Foundation
import SwiftData

@Model
final class UserSettings {
    @Attribute(.unique) var id: UUID
    var dailyConsumption: Int
    var packPrice: Double
    var cigarettesPerPack: Int
    var hasCompletedOnboarding: Bool
    var quitDate: Date

    init(
        id: UUID = UUID(),
        dailyConsumption: Int = 10,
        packPrice: Double = 7.50,
        cigarettesPerPack: Int = 20,
        hasCompletedOnboarding: Bool = false,
        quitDate: Date = .now
    ) {
        self.id = id
        self.dailyConsumption = dailyConsumption
        self.packPrice = packPrice
        self.cigarettesPerPack = cigarettesPerPack
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.quitDate = quitDate
    }

    var pricePerCigarette: Double {
        guard cigarettesPerPack > 0 else { return 0 }
        return packPrice / Double(cigarettesPerPack)
    }
}
