# FitTrack — iOS Gym Tracker

A native iPhone app built in Xcode for logging workouts, tracking body weight, and visualizing fitness progression over time.

---

## Core Features

### 1. Calendar View
- Pick any day from a monthly calendar
- Days with logged workouts display a color-coded badge (push/pull/legs/rest)
- Tap a day to view or create that day's entry

### 2. Split Selection
Choose the training split for the selected day:
- **Push** — chest, shoulders, triceps
- **Pull** — back, biceps
- **Legs** — quads, hamstrings, glutes, calves
- **Rest** — active recovery or off day

### 3. Workout Logging
After selecting a split, add exercises for that session:
- Search or browse an exercise library organized by muscle group
- Add custom exercises
- Reorder exercises via drag-and-drop

### 4. Sets · Reps · Weight
For each exercise, log individual sets:
- Number of sets
- Reps per set
- Weight (lbs or kg toggle)
- Optional: rest timer between sets

### 5. Body Weight Tracking
- Dedicated section separate from workout logs
- Log daily body weight with a timestamp
- Unit toggle: lbs / kg

### 6. Progress Dashboards
Visual charts and stats surfaced on a dashboard tab:
- **Volume over time** — total weight lifted per session, grouped by split or muscle group
- **Personal Records (PRs)** — heaviest weight and highest reps per exercise, highlighted when broken
- **Body weight trend** — line chart over selectable time ranges (1W / 1M / 3M / 1Y / All)
- **Workout frequency heatmap** — GitHub-style contribution grid showing training consistency
- **Streak tracker** — current and longest consecutive training streaks

---

## Technical Stack

| Layer | Choice |
|---|---|
| Platform | iOS (iPhone) |
| Language | Swift |
| UI Framework | SwiftUI |
| IDE | Xcode |
| Data Persistence | SwiftData (iOS 17+) or Core Data |
| Charts | Swift Charts (iOS 16+) |
| Minimum iOS Target | iOS 17 (recommended) |

---

## Proposed App Structure

```
FitTrack/
├── App/
│   └── FitTrackApp.swift
├── Models/
│   ├── WorkoutDay.swift        (date, split, [Exercise])
│   ├── Exercise.swift          (name, muscleGroup, [WorkoutSet])
│   ├── WorkoutSet.swift        (setNumber, reps, weight, unit)
│   ├── BodyWeightEntry.swift   (date, weight, unit)
│   └── Split.swift             (enum: push/pull/legs/rest)
├── Views/
│   ├── Calendar/
│   │   ├── CalendarView.swift
│   │   └── DaySummaryView.swift
│   ├── Workout/
│   │   ├── SplitPickerView.swift
│   │   ├── WorkoutView.swift
│   │   ├── ExercisePickerView.swift
│   │   └── SetEditorView.swift
│   ├── BodyWeight/
│   │   ├── BodyWeightEntryView.swift
│   │   └── WeightHistoryView.swift
│   └── Dashboard/
│       ├── DashboardView.swift
│       ├── VolumeChartView.swift
│       ├── PRsView.swift
│       ├── BodyWeightChartView.swift
│       └── FrequencyHeatmapView.swift
└── ViewModels/
    ├── WorkoutViewModel.swift
    ├── BodyWeightViewModel.swift
    └── DashboardViewModel.swift
```

---

## Data Models (Swift)

```swift
@Model
class WorkoutDay {
    var date: Date
    var split: Split
    var exercises: [Exercise]
}

@Model
class Exercise {
    var name: String
    var muscleGroup: String
    var sets: [WorkoutSet]
    var order: Int
}

@Model
class WorkoutSet {
    var setNumber: Int
    var reps: Int
    var weight: Double
    var unit: WeightUnit
}

@Model
class BodyWeightEntry {
    var date: Date
    var weight: Double
    var unit: WeightUnit
}

enum Split: String, Codable { case push, pull, legs, rest }
enum WeightUnit: String, Codable { case lbs, kg }
```

---

## Screens Summary

| Screen | Purpose |
|---|---|
| Calendar | Entry point — see training history at a glance |
| Day Detail | View/edit the split and exercises for one day |
| Split Picker | Select push / pull / legs / rest |
| Workout | List exercises for the day; add, remove, reorder |
| Set Editor | Log sets with reps + weight for one exercise |
| Body Weight | Log today's weight; view history list |
| Dashboard | Charts and stats for progression |

---

## Future Ideas
- iCloud sync via CloudKit
- Apple Watch companion for logging sets mid-workout
- Plate calculator
- Workout templates (e.g. save a "Push Day A" template)
- Export to CSV
