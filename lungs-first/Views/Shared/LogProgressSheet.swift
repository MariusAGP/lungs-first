import SwiftUI
import SwiftData

struct LogProgressSheet: View {
    let userChallenge: UserChallenge

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var integerValue: Int = 1
    @State private var decimalValueText: String = ""
    @State private var note: String = ""

    private var unit: String { userChallenge.challenge?.unit ?? "" }

    // Money challenges accept fractional values (€3.50), everything else
    // is integer-only
    private var isMoneyUnit: Bool {
        unit.lowercased().contains("euro")
    }

    private var parsedDecimal: Double? {
        let normalized = decimalValueText.replacingOccurrences(of: ",", with: ".")
        return Double(normalized)
    }

    private var canSave: Bool {
        if isMoneyUnit { return (parsedDecimal ?? 0) > 0 }
        return integerValue > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("How much?") {
                    if isMoneyUnit {
                        HStack {
                            Image(systemName: "eurosign.circle.fill")
                                .foregroundStyle(.secondary)
                            TextField("Amount", text: $decimalValueText)
                                .keyboardType(.decimalPad)
                            Text("€")
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Stepper(value: $integerValue, in: 1...500) {
                            Text("\(integerValue) \(unit)")
                        }
                    }
                }

                Section("Note (optional)") {
                    TextField("Add a note", text: $note, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section {
                    Button(action: save) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.primaryGreen)
                    .disabled(!canSave)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Log Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func save() {
        let value: Double = isMoneyUnit ? (parsedDecimal ?? 0) : Double(integerValue)
        guard value > 0 else { return }

        let trimmed = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let entry = LogEntry(
            userChallenge: userChallenge,
            date: .now,
            value: value,
            note: trimmed.isEmpty ? nil : trimmed
        )
        modelContext.insert(entry)

        let progress = ProgressCalculator.progress(for: userChallenge, currentStreak: 0)
        if ProgressCalculator.isComplete(progress) {
            userChallenge.isCompleted = true
            userChallenge.completedAt = .now
        }

        try? modelContext.save()
        BadgeService.evaluate(context: modelContext)
        try? modelContext.save()
        dismiss()
    }
}
