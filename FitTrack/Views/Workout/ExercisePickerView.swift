import SwiftUI

struct ExercisePickerView: View {
    let split: Split
    var onAdd: (_ name: String, _ muscleGroup: String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var search = ""
    @State private var showingCustom = false

    private var groups: [(muscleGroup: String, exercises: [LibraryExercise])] {
        let base = ExerciseLibrary.grouped(for: split)
        guard !search.isEmpty else { return base }
        return base.compactMap { group in
            let filtered = group.exercises.filter {
                $0.name.localizedCaseInsensitiveContains(search)
            }
            return filtered.isEmpty ? nil : (group.muscleGroup, filtered)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(groups, id: \.muscleGroup) { group in
                    Section(group.muscleGroup) {
                        ForEach(group.exercises) { item in
                            Button {
                                onAdd(item.name, item.muscleGroup)
                                dismiss()
                            } label: {
                                Text(item.name)
                                    .foregroundStyle(Color.lime)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                }

                Section {
                    Button {
                        showingCustom = true
                    } label: {
                        Label("Add Custom Exercise", systemImage: "plus")
                    }
                }
            }
            .searchable(text: $search, prompt: "Search exercises")
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(isPresented: $showingCustom) {
                CustomExerciseView(defaultGroup: split.muscleGroups.first ?? "Other") { name, group in
                    onAdd(name, group)
                    dismiss()
                }
            }
        }
    }
}

private struct CustomExerciseView: View {
    let defaultGroup: String
    var onAdd: (_ name: String, _ muscleGroup: String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var muscleGroup: String

    init(defaultGroup: String, onAdd: @escaping (String, String) -> Void) {
        self.defaultGroup = defaultGroup
        self.onAdd = onAdd
        _muscleGroup = State(initialValue: defaultGroup)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Exercise") {
                    TextField("Name", text: $name)
                }
                Section("Muscle Group") {
                    Picker("Muscle Group", selection: $muscleGroup) {
                        ForEach(ExerciseLibrary.orderedMuscleGroups, id: \.self) { group in
                            Text(group).tag(group)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Custom Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        onAdd(name.trimmingCharacters(in: .whitespaces), muscleGroup)
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
