import SwiftUI
import SwiftData

@main
struct FitTrackApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(
                for: WorkoutDay.self, Exercise.self, WorkoutSet.self, BodyWeightEntry.self
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}

struct RootView: View {
    var body: some View {
        TabView {
            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }

            WeightHistoryView()
                .tabItem { Label("Body Weight", systemImage: "scalemass") }

            DashboardView()
                .tabItem { Label("Dashboard", systemImage: "chart.xyaxis.line") }
        }
    }
}
