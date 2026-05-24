import SwiftUI
import SwiftData

private struct SelectedDay: Identifiable, Hashable {
    let date: Date
    var id: Date { date }
}

struct CalendarView: View {
    @Query(sort: \WorkoutDay.date) private var days: [WorkoutDay]
    @State private var visibleMonth: Date = Calendar.current.startOfDay(for: Date())
    @State private var selectedDate: SelectedDay?

    private let calendar = Calendar.current

    private var daysByKey: [String: WorkoutDay] {
        Dictionary(days.map { (Formatting.dayKey.string(from: $0.date), $0) }) { first, _ in first }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    monthHeader
                    weekdayHeader
                    monthGrid
                    legend
                }
                .padding()
            }
            .navigationTitle("FitTrack")
            .navigationDestination(item: $selectedDate) { selection in
                DaySummaryView(date: selection.date)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Today") { withAnimation { visibleMonth = calendar.startOfDay(for: Date()) } }
                }
            }
        }
    }

    private var monthHeader: some View {
        HStack {
            Button { changeMonth(by: -1) } label: {
                Image(systemName: "chevron.left").font(.headline)
            }
            Spacer()
            Text(monthTitle)
                .font(.title2.bold())
            Spacer()
            Button { changeMonth(by: 1) } label: {
                Image(systemName: "chevron.right").font(.headline)
            }
        }
    }

    private var weekdayHeader: some View {
        HStack {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var monthGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)
        return LazyVGrid(columns: columns, spacing: 6) {
            ForEach(Array(monthDays.enumerated()), id: \.offset) { _, date in
                if let date {
                    DayCell(
                        date: date,
                        workout: daysByKey[Formatting.dayKey.string(from: date)],
                        isToday: calendar.isDateInToday(date)
                    )
                    .onTapGesture { selectedDate = SelectedDay(date: date) }
                } else {
                    Color.clear.frame(height: 44)
                }
            }
        }
    }

    private var legend: some View {
        HStack(spacing: 16) {
            ForEach(Split.allCases) { split in
                HStack(spacing: 5) {
                    Circle().fill(split.color).frame(width: 9, height: 9)
                    Text(split.title).font(.caption2)
                }
            }
        }
        .padding(.top, 4)
    }

    // MARK: - Date math

    private var monthTitle: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: visibleMonth)
    }

    private var weekdaySymbols: [String] {
        let symbols = calendar.veryShortStandaloneWeekdaySymbols
        let first = calendar.firstWeekday - 1
        return Array(symbols[first...] + symbols[..<first])
    }

    /// Returns the days of the visible month padded with nils so the 1st lands on the right weekday.
    private var monthDays: [Date?] {
        guard let interval = calendar.dateInterval(of: .month, for: visibleMonth),
              let range = calendar.range(of: .day, in: .month, for: visibleMonth) else { return [] }
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        let leadingBlanks = (firstWeekday - calendar.firstWeekday + 7) % 7
        var cells: [Date?] = Array(repeating: nil, count: leadingBlanks)
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: interval.start) {
                cells.append(date)
            }
        }
        return cells
    }

    private func changeMonth(by value: Int) {
        if let next = calendar.date(byAdding: .month, value: value, to: visibleMonth) {
            withAnimation { visibleMonth = next }
        }
    }
}

private struct DayCell: View {
    let date: Date
    let workout: WorkoutDay?
    let isToday: Bool

    private var dayNumber: String {
        "\(Calendar.current.component(.day, from: date))"
    }

    var body: some View {
        VStack(spacing: 4) {
            Text(dayNumber)
                .font(.callout)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundStyle(isToday ? Color.accentColor : .primary)
            Circle()
                .fill(workout?.split.color ?? .clear)
                .frame(width: 7, height: 7)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(workout != nil ? workout!.split.color.opacity(0.12) : Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(isToday ? Color.accentColor : .clear, lineWidth: 1.5)
        )
    }
}
