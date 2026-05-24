import SwiftUI
import SwiftData

struct DaySummaryView: View {
    let date: Date
    @Environment(\.modelContext) private var context
    @Query private var matches: [WorkoutDay]

    init(date: Date) {
        let start = Calendar.current.startOfDay(for: date)
        self.date = start
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? start
        _matches = Query(filter: #Predicate<WorkoutDay> { $0.date >= start && $0.date < end })
    }

    private var day: WorkoutDay? { matches.first }

    var body: some View {
        Group {
            if let day {
                WorkoutView(day: day, onDelete: { delete(day) })
            } else {
                SplitPickerView { split in
                    let newDay = WorkoutDay(date: date, split: split)
                    context.insert(newDay)
                }
            }
        }
        .navigationTitle(navTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var navTitle: String {
        let f = DateFormatter()
        f.dateFormat = "EEE, MMM d"
        return f.string(from: date)
    }

    private func delete(_ day: WorkoutDay) {
        context.delete(day)
    }
}
