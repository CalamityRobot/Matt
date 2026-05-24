import SwiftUI
import SwiftData

struct SetEditorView: View {
    @Bindable var exercise: Exercise
    @Environment(\.modelContext) private var context
    @AppStorage("preferredUnit") private var preferredUnitRaw = WeightUnit.lbs.rawValue

    private var preferredUnit: WeightUnit {
        WeightUnit(rawValue: preferredUnitRaw) ?? .lbs
    }

    var body: some View {
        List {
            Section {
                ForEach(exercise.orderedSets) { set in
                    SetRow(set: set)
                }
                .onDelete(perform: deleteSets)

                Button {
                    addSet()
                } label: {
                    Label("Add Set", systemImage: "plus.circle.fill")
                }
            } header: {
                Text("Sets")
            } footer: {
                if !exercise.sets.isEmpty {
                    Text("Volume: \(Formatting.volume(exercise.volumeInLbs, unit: preferredUnit))")
                }
            }

            RestTimerSection()
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { EditButton() }
    }

    private func addSet() {
        let last = exercise.orderedSets.last
        let set = WorkoutSet(
            setNumber: exercise.sets.count + 1,
            reps: last?.reps ?? 10,
            weight: last?.weight ?? 0,
            unit: last?.unit ?? preferredUnit
        )
        set.exercise = exercise
        exercise.sets.append(set)
    }

    private func deleteSets(at offsets: IndexSet) {
        let ordered = exercise.orderedSets
        for index in offsets {
            context.delete(ordered[index])
        }
        for (index, set) in exercise.orderedSets.enumerated() {
            set.setNumber = index + 1
        }
    }
}

private struct SetRow: View {
    @Bindable var set: WorkoutSet

    var body: some View {
        HStack(spacing: 12) {
            Text("\(set.setNumber)")
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text("Reps").font(.caption2).foregroundStyle(.secondary)
                Stepper(value: $set.reps, in: 0...100) {
                    Text("\(set.reps)").monospacedDigit()
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Weight").font(.caption2).foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    TextField("0", value: $set.weight, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 56)
                        .textFieldStyle(.roundedBorder)
                    Picker("Unit", selection: $set.unit) {
                        ForEach(WeightUnit.allCases) { unit in
                            Text(unit.label).tag(unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 88)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

private struct RestTimerSection: View {
    @State private var remaining = 0
    @State private var running = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Section("Rest Timer") {
            HStack {
                Text(timeString)
                    .font(.system(.title2, design: .monospaced))
                    .foregroundStyle(running ? Color.accentColor : .primary)
                Spacer()
                Button(running ? "Pause" : "Start") {
                    running.toggle()
                }
                .buttonStyle(.bordered)
                .disabled(remaining == 0)
                Button("Reset") {
                    running = false
                    remaining = 0
                }
                .buttonStyle(.bordered)
                .disabled(remaining == 0 && !running)
            }
            HStack(spacing: 8) {
                ForEach([30, 60, 90, 120], id: \.self) { seconds in
                    Button("\(seconds)s") {
                        remaining = seconds
                        running = true
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .onReceive(timer) { _ in
            guard running, remaining > 0 else { return }
            remaining -= 1
            if remaining == 0 { running = false }
        }
    }

    private var timeString: String {
        String(format: "%02d:%02d", remaining / 60, remaining % 60)
    }
}
