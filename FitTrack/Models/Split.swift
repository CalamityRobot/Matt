import SwiftUI

enum Split: String, Codable, CaseIterable, Identifiable {
    case push
    case pull
    case legs
    case rest

    var id: String { rawValue }

    var title: String {
        switch self {
        case .push: return "Push"
        case .pull: return "Pull"
        case .legs: return "Legs"
        case .rest: return "Rest"
        }
    }

    var subtitle: String {
        switch self {
        case .push: return "Chest · Shoulders · Triceps"
        case .pull: return "Back · Biceps"
        case .legs: return "Quads · Hamstrings · Glutes · Calves"
        case .rest: return "Active recovery or off day"
        }
    }

    var symbol: String {
        switch self {
        case .push: return "figure.strengthtraining.traditional"
        case .pull: return "figure.rower"
        case .legs: return "figure.run"
        case .rest: return "bed.double.fill"
        }
    }

    var color: Color {
        switch self {
        case .push: return .blue
        case .pull: return .purple
        case .legs: return .orange
        case .rest: return .gray
        }
    }

    /// Muscle groups associated with this split, used to filter the exercise library.
    var muscleGroups: [String] {
        switch self {
        case .push: return ["Chest", "Shoulders", "Triceps"]
        case .pull: return ["Back", "Biceps"]
        case .legs: return ["Quads", "Hamstrings", "Glutes", "Calves"]
        case .rest: return []
        }
    }
}

enum WeightUnit: String, Codable, CaseIterable, Identifiable {
    case lbs
    case kg

    var id: String { rawValue }
    var label: String { rawValue }
}
