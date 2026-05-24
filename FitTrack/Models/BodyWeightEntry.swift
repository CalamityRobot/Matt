import Foundation
import SwiftData

@Model
final class BodyWeightEntry {
    var date: Date
    var weight: Double
    var unit: WeightUnit

    init(date: Date, weight: Double, unit: WeightUnit) {
        self.date = date
        self.weight = weight
        self.unit = unit
    }

    var weightInLbs: Double {
        unit == .kg ? weight * 2.2046226218 : weight
    }

    var weightInKg: Double {
        unit == .lbs ? weight / 2.2046226218 : weight
    }

    func weight(in unit: WeightUnit) -> Double {
        unit == .kg ? weightInKg : weightInLbs
    }
}
