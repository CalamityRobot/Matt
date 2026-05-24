import Foundation

struct LibraryExercise: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let muscleGroup: String
}

/// A static catalog of common exercises, grouped by muscle group. Users can also
/// add custom exercises that won't appear here but are stored on the workout.
enum ExerciseLibrary {
    static let all: [LibraryExercise] = [
        // Chest
        .init(name: "Barbell Bench Press", muscleGroup: "Chest"),
        .init(name: "Incline Dumbbell Press", muscleGroup: "Chest"),
        .init(name: "Cable Fly", muscleGroup: "Chest"),
        .init(name: "Push-Up", muscleGroup: "Chest"),
        .init(name: "Machine Chest Press", muscleGroup: "Chest"),
        // Shoulders
        .init(name: "Overhead Press", muscleGroup: "Shoulders"),
        .init(name: "Dumbbell Lateral Raise", muscleGroup: "Shoulders"),
        .init(name: "Face Pull", muscleGroup: "Shoulders"),
        .init(name: "Arnold Press", muscleGroup: "Shoulders"),
        // Triceps
        .init(name: "Tricep Pushdown", muscleGroup: "Triceps"),
        .init(name: "Overhead Tricep Extension", muscleGroup: "Triceps"),
        .init(name: "Close-Grip Bench Press", muscleGroup: "Triceps"),
        .init(name: "Dip", muscleGroup: "Triceps"),
        // Back
        .init(name: "Deadlift", muscleGroup: "Back"),
        .init(name: "Pull-Up", muscleGroup: "Back"),
        .init(name: "Bent-Over Barbell Row", muscleGroup: "Back"),
        .init(name: "Lat Pulldown", muscleGroup: "Back"),
        .init(name: "Seated Cable Row", muscleGroup: "Back"),
        // Biceps
        .init(name: "Barbell Curl", muscleGroup: "Biceps"),
        .init(name: "Dumbbell Hammer Curl", muscleGroup: "Biceps"),
        .init(name: "Preacher Curl", muscleGroup: "Biceps"),
        .init(name: "Cable Curl", muscleGroup: "Biceps"),
        // Quads
        .init(name: "Back Squat", muscleGroup: "Quads"),
        .init(name: "Front Squat", muscleGroup: "Quads"),
        .init(name: "Leg Press", muscleGroup: "Quads"),
        .init(name: "Leg Extension", muscleGroup: "Quads"),
        .init(name: "Walking Lunge", muscleGroup: "Quads"),
        // Hamstrings
        .init(name: "Romanian Deadlift", muscleGroup: "Hamstrings"),
        .init(name: "Lying Leg Curl", muscleGroup: "Hamstrings"),
        .init(name: "Seated Leg Curl", muscleGroup: "Hamstrings"),
        .init(name: "Good Morning", muscleGroup: "Hamstrings"),
        // Glutes
        .init(name: "Hip Thrust", muscleGroup: "Glutes"),
        .init(name: "Glute Bridge", muscleGroup: "Glutes"),
        .init(name: "Bulgarian Split Squat", muscleGroup: "Glutes"),
        // Calves
        .init(name: "Standing Calf Raise", muscleGroup: "Calves"),
        .init(name: "Seated Calf Raise", muscleGroup: "Calves"),
    ]

    static func grouped(for split: Split) -> [(muscleGroup: String, exercises: [LibraryExercise])] {
        let groups = split.muscleGroups
        let relevant = groups.isEmpty ? orderedMuscleGroups : groups
        return relevant.compactMap { group in
            let items = all.filter { $0.muscleGroup == group }
            return items.isEmpty ? nil : (group, items)
        }
    }

    static var orderedMuscleGroups: [String] {
        var seen = Set<String>()
        return all.compactMap { seen.insert($0.muscleGroup).inserted ? $0.muscleGroup : nil }
    }
}
