import SwiftUI
import SwiftData

struct BodyWeightEntryView: View {
    let defaultUnit: WeightUnit
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var weight: Double?
    @State private var unit: WeightUnit
    @State private var date = Date()

    init(defaultUnit: WeightUnit) {
        self.defaultUnit = defaultUnit
        _unit = State(initialValue: defaultUnit)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Weight") {
                    HStack {
                        TextField("0.0", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                            .font(.title2)
                        Picker("Unit", selection: $unit) {
                            ForEach(WeightUnit.allCases) { unit in
                                Text(unit.label).tag(unit)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 120)
                    }
                }
                Section("When") {
                    DatePicker("Date", selection: $date)
                }
            }
            .navigationTitle("Log Body Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { save() }
                        .disabled((weight ?? 0) <= 0)
                }
            }
        }
    }

    private func save() {
        guard let weight, weight > 0 else { return }
        let entry = BodyWeightEntry(date: date, weight: weight, unit: unit)
        context.insert(entry)
        dismiss()
    }
}
