import SwiftUI

struct FrequencyHeatmapView: View {
    let days: [WorkoutDay]
    private let calendar = Calendar.current
    private let weeks = 17

    private var dayMap: [String: WorkoutDay] {
        Dictionary(days.map { (Formatting.dayKey.string(from: $0.date), $0) }) { a, _ in a }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 3) {
                    ForEach(weekColumns, id: \.self) { week in
                        VStack(spacing: 3) {
                            ForEach(week, id: \.self) { date in
                                cell(for: date)
                            }
                        }
                    }
                }
            }
            HStack(spacing: 6) {
                Text("Less").font(.caption2).foregroundStyle(.secondary)
                ForEach([0.15, 0.4, 0.7, 1.0], id: \.self) { opacity in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.accentColor.opacity(opacity))
                        .frame(width: 12, height: 12)
                }
                Text("More").font(.caption2).foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private func cell(for date: Date) -> some View {
        let workout = dayMap[Formatting.dayKey.string(from: date)]
        let isFuture = date > calendar.startOfDay(for: Date())
        RoundedRectangle(cornerRadius: 2)
            .fill(color(for: workout, isFuture: isFuture))
            .frame(width: 13, height: 13)
    }

    private func color(for workout: WorkoutDay?, isFuture: Bool) -> Color {
        guard !isFuture else { return .clear }
        guard let workout, workout.split != .rest else {
            return Color(.systemGray5)
        }
        let intensity = min(1.0, 0.3 + Double(workout.totalSets) * 0.12)
        return workout.split.color.opacity(intensity)
    }

    /// Builds columns of 7-day weeks ending today, oldest week first.
    private var weekColumns: [[Date]] {
        let today = calendar.startOfDay(for: Date())
        let weekday = (calendar.component(.weekday, from: today) - calendar.firstWeekday + 7) % 7
        guard let endOfWeek = calendar.date(byAdding: .day, value: 6 - weekday, to: today),
              let start = calendar.date(byAdding: .day, value: -(weeks * 7 - 1), to: endOfWeek)
        else { return [] }

        var columns: [[Date]] = []
        var cursor = start
        for _ in 0..<weeks {
            var column: [Date] = []
            for _ in 0..<7 {
                column.append(cursor)
                cursor = calendar.date(byAdding: .day, value: 1, to: cursor)!
            }
            columns.append(column)
        }
        return columns
    }
}
