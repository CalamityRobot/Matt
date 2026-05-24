import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \WorkoutDay.date) private var allDays: [WorkoutDay]
    @Query(sort: \BodyWeightEntry.date) private var bodyWeights: [BodyWeightEntry]
    @AppStorage("preferredUnit") private var preferredUnitRaw = WeightUnit.lbs.rawValue
    @State private var range: TimeRange = .month

    private var preferredUnit: WeightUnit {
        WeightUnit(rawValue: preferredUnitRaw) ?? .lbs
    }

    private var rangedDays: [WorkoutDay] {
        WorkoutStats.days(allDays, in: range)
    }

    private var rangedWeights: [BodyWeightEntry] {
        guard let start = range.startDate() else { return bodyWeights }
        return bodyWeights.filter { $0.date >= start }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    rangePicker
                    streakCard
                    card(title: "Volume per Session", systemImage: "chart.bar.fill") {
                        VolumeChartView(days: rangedDays, unit: preferredUnit)
                    }
                    card(title: "Body Weight Trend", systemImage: "scalemass.fill") {
                        if rangedWeights.isEmpty {
                            Text("No weigh-ins in this range.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            BodyWeightChartView(entries: rangedWeights, unit: preferredUnit)
                                .frame(height: 200)
                        }
                    }
                    card(title: "Training Frequency", systemImage: "square.grid.3x3.fill") {
                        FrequencyHeatmapView(days: allDays)
                    }
                    card(title: "Personal Records", systemImage: "trophy.fill") {
                        PRsView(records: WorkoutStats.personalRecords(allDays), unit: preferredUnit)
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }

    private var rangePicker: some View {
        Picker("Range", selection: $range) {
            ForEach(TimeRange.allCases) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
    }

    private var streakCard: some View {
        HStack(spacing: 12) {
            statTile(
                value: "\(WorkoutStats.currentStreak(allDays))",
                label: "Current Streak",
                systemImage: "flame.fill",
                color: .orange
            )
            statTile(
                value: "\(WorkoutStats.longestStreak(allDays))",
                label: "Longest Streak",
                systemImage: "crown.fill",
                color: .yellow
            )
            statTile(
                value: "\(rangedDays.filter { $0.split != .rest }.count)",
                label: "Sessions",
                systemImage: "dumbbell.fill",
                color: .blue
            )
        }
    }

    private func statTile(value: String, label: String, systemImage: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(color)
            Text(value).font(.title2.bold())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
    }

    private func card<Content: View>(
        title: String,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}
