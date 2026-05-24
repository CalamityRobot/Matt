import Foundation

enum Formatting {
    static func weight(_ value: Double, unit: WeightUnit) -> String {
        let rounded = (value * 10).rounded() / 10
        let number = rounded == rounded.rounded()
            ? String(format: "%.0f", rounded)
            : String(format: "%.1f", rounded)
        return "\(number) \(unit.label)"
    }

    static func volume(_ lbs: Double, unit: WeightUnit) -> String {
        let value = unit == .kg ? lbs / 2.2046226218 : lbs
        if value >= 1000 {
            return String(format: "%.1fk %@", value / 1000, unit.label)
        }
        return String(format: "%.0f %@", value, unit.label)
    }

    static let dayKey: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
}
