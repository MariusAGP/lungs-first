import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allSettings: [UserSettings]

    @State private var dailyConsumption: Int = 10
    @State private var packPriceText: String = "7.50"
    @State private var cigarettesPerPack: Int = 20

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "lungs.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(Color.primaryGreen)
                        Text("Welcome to LungsFirst")
                            .font(.title2.bold())
                        Text("A few quick questions to personalize your journey.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.clear)

                Section("Cigarettes per day") {
                    Stepper(value: $dailyConsumption, in: 1...60) {
                        HStack {
                            Image(systemName: "smoke.fill")
                                .foregroundStyle(.secondary)
                            Text("\(dailyConsumption) per day")
                        }
                    }
                }

                Section("Pack price (€)") {
                    HStack {
                        Image(systemName: "eurosign.circle.fill")
                            .foregroundStyle(.secondary)
                        TextField("7.50", text: $packPriceText)
                            .keyboardType(.decimalPad)
                    }
                }

                Section("Cigarettes per pack") {
                    Stepper(value: $cigarettesPerPack, in: 10...30) {
                        HStack {
                            Image(systemName: "rectangle.fill")
                                .foregroundStyle(.secondary)
                            Text("\(cigarettesPerPack) per pack")
                        }
                    }
                }

                Section {
                    Button(action: save) {
                        Text("Get Started")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.primaryGreen)
                    .disabled(parsedPackPrice == nil)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Setup")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
        }
    }

    private var parsedPackPrice: Double? {
        let normalized = packPriceText.replacingOccurrences(of: ",", with: ".")
        return Double(normalized)
    }

    private func save() {
        guard let price = parsedPackPrice else { return }
        if let existing = allSettings.first {
            existing.dailyConsumption = dailyConsumption
            existing.packPrice = price
            existing.cigarettesPerPack = cigarettesPerPack
            existing.hasCompletedOnboarding = true
            existing.quitDate = .now
        } else {
            let settings = UserSettings(
                dailyConsumption: dailyConsumption,
                packPrice: price,
                cigarettesPerPack: cigarettesPerPack,
                hasCompletedOnboarding: true,
                quitDate: .now
            )
            modelContext.insert(settings)
        }
        try? modelContext.save()
    }
}
