import SwiftUI

struct PRsView: View {
    let records: [PersonalRecord]
    let unit: WeightUnit

    var body: some View {
        if records.isEmpty {
            Text("Log weighted sets to start tracking PRs.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } else {
            VStack(spacing: 10) {
                ForEach(records.prefix(8)) { record in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(record.exercise).font(.subheadline.weight(.medium))
                            Text(record.muscleGroup).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(Formatting.weight(weight(record.topWeightLbs), unit: unit))
                                .font(.subheadline.bold())
                                .foregroundStyle(Color.accentColor)
                            Text("\(record.topReps) rep max")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    if record.id != records.prefix(8).last?.id {
                        Divider()
                    }
                }
            }
        }
    }

    private func weight(_ lbs: Double) -> Double {
        unit == .kg ? lbs / 2.2046226218 : lbs
    }
}
