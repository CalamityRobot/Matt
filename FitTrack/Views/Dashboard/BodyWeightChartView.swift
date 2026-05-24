import SwiftUI
import Charts

struct BodyWeightChartView: View {
    let entries: [BodyWeightEntry]
    let unit: WeightUnit

    private var sorted: [BodyWeightEntry] {
        entries.sorted { $0.date < $1.date }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let latest = sorted.last {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(Formatting.weight(latest.weight(in: unit), unit: unit))
                        .font(.title2.bold())
                    if let change = changeText {
                        Text(change.text)
                            .font(.caption)
                            .foregroundStyle(change.color)
                    }
                }
            }
            Chart(sorted) { entry in
                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Weight", entry.weight(in: unit))
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Color.accentColor)

                PointMark(
                    x: .value("Date", entry.date),
                    y: .value("Weight", entry.weight(in: unit))
                )
                .foregroundStyle(Color.accentColor)
                .symbolSize(28)
            }
            .chartYScale(domain: yDomain)
            .padding(.horizontal, 4)
        }
        .padding(.horizontal)
    }

    private var yDomain: ClosedRange<Double> {
        let values = sorted.map { $0.weight(in: unit) }
        guard let min = values.min(), let max = values.max() else { return 0...100 }
        let padding = Swift.max((max - min) * 0.2, 2)
        return (min - padding)...(max + padding)
    }

    private var changeText: (text: String, color: Color)? {
        guard sorted.count >= 2 else { return nil }
        let delta = sorted.last!.weight(in: unit) - sorted.first!.weight(in: unit)
        let arrow = delta > 0 ? "▲" : (delta < 0 ? "▼" : "–")
        let color: Color = delta > 0 ? .red : (delta < 0 ? .green : .secondary)
        return ("\(arrow) \(Formatting.weight(abs(delta), unit: unit))", color)
    }
}
