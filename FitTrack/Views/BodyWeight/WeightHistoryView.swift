import SwiftUI
import SwiftData

struct WeightHistoryView: View {
    @Query(sort: \BodyWeightEntry.date, order: .reverse) private var entries: [BodyWeightEntry]
    @Environment(\.modelContext) private var context
    @AppStorage("preferredUnit") private var preferredUnitRaw = WeightUnit.lbs.rawValue
    @State private var showingEntry = false

    private var preferredUnit: WeightUnit {
        WeightUnit(rawValue: preferredUnitRaw) ?? .lbs
    }

    var body: some View {
        NavigationStack {
            List {
                if !entries.isEmpty {
                    Section {
                        BodyWeightChartView(entries: entries, unit: preferredUnit)
                            .frame(height: 220)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 8)
                    }
                }

                Section("History") {
                    if entries.isEmpty {
                        ContentUnavailableView(
                            "No weigh-ins yet",
                            systemImage: "scalemass",
                            description: Text("Log your body weight to see your trend over time.")
                        )
                    }
                    ForEach(entries) { entry in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(Formatting.weight(entry.weight(in: preferredUnit), unit: preferredUnit))
                                    .font(.headline)
                                Text(entry.date, format: .dateTime.weekday().month().day().hour().minute())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                    }
                    .onDelete(perform: deleteEntries)
                }
            }
            .navigationTitle("Body Weight")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingEntry = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Unit", selection: $preferredUnitRaw) {
                            ForEach(WeightUnit.allCases) { unit in
                                Text(unit.label).tag(unit.rawValue)
                            }
                        }
                    } label: {
                        Text(preferredUnit.label.uppercased())
                    }
                }
            }
            .sheet(isPresented: $showingEntry) {
                BodyWeightEntryView(defaultUnit: preferredUnit)
            }
        }
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            context.delete(entries[index])
        }
    }
}
