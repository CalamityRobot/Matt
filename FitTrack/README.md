# FitTrack

A native iPhone app for logging workouts, tracking body weight, and visualizing
fitness progression over time. Built with SwiftUI and SwiftData.

**Current version: 1.0.2**

---

## Features

- **Calendar** — monthly grid with color-coded split badges; tap any day to create or edit a workout.
- **Splits** — Push, Pull, Legs, and Rest, each with its own color and associated muscle groups.
- **Workout logging** — browse a 35-exercise library grouped by muscle group, add custom exercises, reorder via drag-and-drop, and swipe to delete.
- **Set editor** — log reps and weight per set with an lbs/kg toggle, plus a built-in rest timer (30 / 60 / 90 / 120s).
- **Body weight** — log weigh-ins with a timestamp and watch the trend on a live line chart.
- **Dashboard** — volume-per-session bars, personal records, body weight trend, a GitHub-style frequency heatmap, and current/longest streak tiles, all filterable by 1W / 1M / 3M / 1Y / All.

## Tech stack

| Layer | Choice |
|---|---|
| Platform | iOS 17+ (iPhone) |
| Language | Swift |
| UI | SwiftUI |
| Persistence | SwiftData |
| Charts | Swift Charts |
| IDE | Xcode 26+ |

## Project structure

```
FitTrack/
├── App/                FitTrackApp entry point + root TabView
├── Models/             SwiftData @Model types, enums, exercise library, formatting
├── ViewModels/         WorkoutStats (PRs, streaks, range filtering)
└── Views/
    ├── Calendar/       CalendarView, DaySummaryView
    ├── Workout/        SplitPickerView, WorkoutView, ExercisePickerView, SetEditorView
    ├── BodyWeight/     BodyWeightEntryView, WeightHistoryView
    └── Dashboard/      DashboardView + chart/heatmap/PR views
```

## Build & run

1. Open `FitTrack.xcodeproj` in Xcode.
2. If prompted, install the iOS platform/simulator components.
3. Select the **FitTrack** target → **Signing & Capabilities** → choose your Apple Developer **Team**. The bundle identifier is `com.calamityrobot.FitTrack` — change it if it's already taken.
4. Plug in your iPhone, select it as the run destination, and press Run.

## Versioning

This project follows [Semantic Versioning](https://semver.org/) (`MAJOR.MINOR.PATCH`).
The version below is kept in sync with `MARKETING_VERSION` in the Xcode project.
Every change should add a Changelog entry and bump the version:

- **PATCH** — bug fixes and small tweaks.
- **MINOR** — new backward-compatible features.
- **MAJOR** — breaking changes or major redesigns.

## Changelog

### 1.0.2 — 2026-05-24
- Redesigned the app icon: white bench silhouette on a blue gradient for better legibility at small sizes.

### 1.0.1 — 2026-05-24
- Added a custom app icon (bench press artwork).

### 1.0.0 — 2026-05-24
- Initial release.
- Calendar with color-coded splits and per-day workout entry.
- Workout logging: exercise library, custom exercises, reorder/delete, set editor with lbs/kg toggle and rest timer.
- Body weight tracking with trend chart.
- Dashboard: volume per session, personal records, body weight trend, frequency heatmap, and streak tracking with selectable time ranges.
