import Foundation

enum TimeRange: String, CaseIterable, Identifiable {
    case week = "1W"
    case month = "1M"
    case threeMonths = "3M"
    case year = "1Y"
    case all = "All"

    var id: String { rawValue }

    /// The earliest date included in this range, or nil for `.all`.
    func startDate(now: Date = Date()) -> Date? {
        let cal = Calendar.current
        switch self {
        case .week: return cal.date(byAdding: .day, value: -7, to: now)
        case .month: return cal.date(byAdding: .month, value: -1, to: now)
        case .threeMonths: return cal.date(byAdding: .month, value: -3, to: now)
        case .year: return cal.date(byAdding: .year, value: -1, to: now)
        case .all: return nil
        }
    }
}

struct PersonalRecord: Identifiable {
    var id: String { exercise }
    let exercise: String
    let muscleGroup: String
    let topWeightLbs: Double
    let topReps: Int
    let bestVolumeLbs: Double
}

enum WorkoutStats {
    /// Filters days to a time range and sorts ascending by date.
    static func days(_ days: [WorkoutDay], in range: TimeRange) -> [WorkoutDay] {
        let filtered: [WorkoutDay]
        if let start = range.startDate() {
            filtered = days.filter { $0.date >= Calendar.current.startOfDay(for: start) }
        } else {
            filtered = days
        }
        return filtered.sorted { $0.date < $1.date }
    }

    /// Personal records per exercise name across all training history.
    static func personalRecords(_ days: [WorkoutDay]) -> [PersonalRecord] {
        var byName: [String: (group: String, weight: Double, reps: Int, volume: Double)] = [:]
        for day in days {
            for exercise in day.exercises {
                var record = byName[exercise.name] ?? (exercise.muscleGroup, 0, 0, 0)
                record.group = exercise.muscleGroup
                for set in exercise.sets {
                    record.weight = max(record.weight, set.weightInLbs)
                    record.reps = max(record.reps, set.reps)
                }
                record.volume = max(record.volume, exercise.volumeInLbs)
                byName[exercise.name] = record
            }
        }
        return byName
            .map { PersonalRecord(exercise: $0.key, muscleGroup: $0.value.group,
                                  topWeightLbs: $0.value.weight, topReps: $0.value.reps,
                                  bestVolumeLbs: $0.value.volume) }
            .sorted { $0.topWeightLbs > $1.topWeightLbs }
    }

    /// Current consecutive-day streak counting back from today, where a logged
    /// non-rest workout continues the streak.
    static func currentStreak(_ days: [WorkoutDay], now: Date = Date()) -> Int {
        let trained = trainedDateSet(days)
        let cal = Calendar.current
        var streak = 0
        var cursor = cal.startOfDay(for: now)
        // Allow the streak to be "alive" even if today isn't logged yet.
        if !trained.contains(cursor) {
            cursor = cal.date(byAdding: .day, value: -1, to: cursor)!
        }
        while trained.contains(cursor) {
            streak += 1
            cursor = cal.date(byAdding: .day, value: -1, to: cursor)!
        }
        return streak
    }

    static func longestStreak(_ days: [WorkoutDay]) -> Int {
        let trained = trainedDateSet(days).sorted()
        guard !trained.isEmpty else { return 0 }
        let cal = Calendar.current
        var longest = 1
        var current = 1
        for i in 1..<trained.count {
            if let prevPlusOne = cal.date(byAdding: .day, value: 1, to: trained[i - 1]),
               cal.isDate(prevPlusOne, inSameDayAs: trained[i]) {
                current += 1
            } else {
                current = 1
            }
            longest = max(longest, current)
        }
        return longest
    }

    private static func trainedDateSet(_ days: [WorkoutDay]) -> Set<Date> {
        let cal = Calendar.current
        return Set(days.filter { $0.split != .rest }.map { cal.startOfDay(for: $0.date) })
    }
}
