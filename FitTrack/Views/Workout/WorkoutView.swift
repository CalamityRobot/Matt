import SwiftUI
import SwiftData

struct WorkoutView: View {
    @Bindable var day: WorkoutDay
    var onDelete: () -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var showingPicker = false
    @State private var showingSplitChange = false

    var body: some View {
        List {
            Section {
                HStack(spacing: 14) {
                    Image(systemName: day.split.symbol)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(day.split.color, in: RoundedRectangle(cornerRadius: 10))
                    VStack(alignment: .leading) {
                        Text(day.split.title).font(.headline)
                        Text(day.split.subtitle).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Menu {
                        ForEach(Split.allCases) { split in
                            Button {
                                day.split = split
                            } label: {
                                Label(split.title, systemImage: split.symbol)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                }
            }

            if day.split == .rest {
                Section {
                    Text("Rest day — no exercises logged. Enjoy the recovery.")
                        .foregroundStyle(.secondary)
                }
            } else {
                Section("Exercises") {
                    if day.orderedExercises.isEmpty {
                        Text("No exercises yet. Tap below to add one.")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(day.orderedExercises) { exercise in
                        NavigationLink {
                            SetEditorView(exercise: exercise)
                        } label: {
                            ExerciseRow(exercise: exercise)
                        }
                    }
                    .onDelete(perform: deleteExercises)
                    .onMove(perform: moveExercises)

                    Button {
                        showingPicker = true
                    } label: {
                        Label("Add Exercise", systemImage: "plus.circle.fill")
                    }
                }
            }

            Section {
                Button(role: .destructive) {
                    onDelete()
                    dismiss()
                } label: {
                    Label("Delete This Day", systemImage: "trash")
                }
            }
        }
        .toolbar {
            if day.split != .rest && !day.orderedExercises.isEmpty {
                EditButton()
            }
        }
        .sheet(isPresented: $showingPicker) {
            ExercisePickerView(split: day.split) { name, muscleGroup in
                addExercise(name: name, muscleGroup: muscleGroup)
            }
        }
    }

    private func addExercise(name: String, muscleGroup: String) {
        let exercise = Exercise(name: name, muscleGroup: muscleGroup, order: day.exercises.count)
        exercise.day = day
        day.exercises.append(exercise)
    }

    private func deleteExercises(at offsets: IndexSet) {
        let ordered = day.orderedExercises
        for index in offsets {
            context.delete(ordered[index])
        }
        reindex()
    }

    private func moveExercises(from source: IndexSet, to destination: Int) {
        var ordered = day.orderedExercises
        ordered.move(fromOffsets: source, toOffset: destination)
        for (index, exercise) in ordered.enumerated() {
            exercise.order = index
        }
    }

    private func reindex() {
        for (index, exercise) in day.orderedExercises.enumerated() {
            exercise.order = index
        }
    }
}

private struct ExerciseRow: View {
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(exercise.name).font(.body)
            HStack(spacing: 6) {
                Text(exercise.muscleGroup)
                if !exercise.sets.isEmpty {
                    Text("·")
                    Text("\(exercise.sets.count) set\(exercise.sets.count == 1 ? "" : "s")")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
}
