import Foundation
import SwiftData

@Model
final class WorkoutDay {
    /// Normalized to the start of the calendar day so each date has at most one entry.
    var date: Date
    var split: Split

    @Relationship(deleteRule: .cascade, inverse: \Exercise.day)
    var exercises: [Exercise] = []

    init(date: Date, split: Split) {
        self.date = Calendar.current.startOfDay(for: date)
        self.split = split
    }

    var orderedExercises: [Exercise] {
        exercises.sorted { $0.order < $1.order }
    }

    /// Total weight moved across every set logged that day, normalized to lbs.
    var totalVolume: Double {
        exercises.reduce(0) { $0 + $1.volumeInLbs }
    }

    var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets.count }
    }
}
