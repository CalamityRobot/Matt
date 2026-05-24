import Foundation
import SwiftData

@Model
final class Exercise {
    var name: String
    var muscleGroup: String
    var order: Int

    @Relationship(deleteRule: .cascade, inverse: \WorkoutSet.exercise)
    var sets: [WorkoutSet] = []

    var day: WorkoutDay?

    init(name: String, muscleGroup: String, order: Int) {
        self.name = name
        self.muscleGroup = muscleGroup
        self.order = order
    }

    var orderedSets: [WorkoutSet] {
        sets.sorted { $0.setNumber < $1.setNumber }
    }

    var volumeInLbs: Double {
        sets.reduce(0) { $0 + $1.volumeInLbs }
    }

    /// Heaviest single set, normalized to lbs.
    var topWeightInLbs: Double {
        sets.map(\.weightInLbs).max() ?? 0
    }
}
