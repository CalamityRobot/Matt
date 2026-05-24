import SwiftUI
import Charts

struct VolumeChartView: View {
    let days: [WorkoutDay]
    let unit: WeightUnit

    private var sessions: [WorkoutDay] {
        days.filter { $0.split != .rest && $0.totalVolume > 0 }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if sessions.isEmpty {
                emptyState
            } else {
                Chart(sessions) { day in
                    BarMark(
                        x: .value("Date", day.date, unit: .day),
                        y: .value("Volume", volume(day))
                    )
                    .foregroundStyle(day.split.color)
                }
                .chartForegroundStyleScale(domain: splitDomain, range: splitColors)
                .frame(height: 200)
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No volume yet",
            systemImage: "chart.bar",
            description: Text("Log some sets to see your training volume per session.")
        )
        .frame(height: 200)
    }

    private func volume(_ day: WorkoutDay) -> Double {
        unit == .kg ? day.totalVolume / 2.2046226218 : day.totalVolume
    }

    private var presentSplits: [Split] {
        var seen = Set<Split>()
        return sessions.compactMap { seen.insert($0.split).inserted ? $0.split : nil }
    }

    private var splitDomain: [String] { presentSplits.map(\.title) }
    private var splitColors: [Color] { presentSplits.map(\.color) }
}
