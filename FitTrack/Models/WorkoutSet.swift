import Foundation
import SwiftData

@Model
final class WorkoutSet {
    var setNumber: Int
    var reps: Int
    var weight: Double
    var unit: WeightUnit

    var exercise: Exercise?

    init(setNumber: Int, reps: Int, weight: Double, unit: WeightUnit) {
        self.setNumber = setNumber
        self.reps = reps
        self.weight = weight
        self.unit = unit
    }

    var weightInLbs: Double {
        unit == .kg ? weight * 2.2046226218 : weight
    }

    var volumeInLbs: Double {
        weightInLbs * Double(reps)
    }
}
