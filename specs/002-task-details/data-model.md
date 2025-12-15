# Data Model: Task Details

**Feature**: 002-task-details  
**Date**: 2025-01-27  
**Phase**: 1 (Design)

## Entities

### Task (Reused)

Represents a shop visit scheduled for today. Reused from home task list feature (001-home-task-list).

**Location**: `Models/Task.swift` (existing)

**Properties**: Same as defined in home task list feature:
- `id: UUID`
- `venueName: String`
- `address: String`
- `openingHours: String`
- `plannedVisitTime: Date`
- `status: TaskStatus`
- `visitingOrder: Int`
- `photoURL: URL`
- `location: CLLocationCoordinate2D`
- `distanceFromCurrentLocation: Double?` (meters, nil if location unavailable)
- `estimatedTravelTime: TimeInterval?` (seconds, nil if distance unavailable)

**Usage in TaskDetails**:
- Task passed as parameter to TaskDetailsBuilder.build()
- TaskDetailsInteractor receives Task and binds to presenter
- TaskDetailsView displays all Task properties

**No new entities required** - TaskDetails RIB reuses existing Task model.

---

## Data Flow

### Streams

1. **TaskDetails receives Task**: Via Builder.build(task:) parameter
   - Task is passed at RIB creation time
   - Static snapshot (no real-time updates in MVP)
   - Future enhancement: Can receive Task updates via Binder from parent

2. **TaskDetailsInteractor → TaskDetailsView**: Task data via Binder
   - Interactor binds Task to presenter.task Binder
   - Presenter updates ViewState.task
   - View observes ViewState and displays Task information

### Data Transformations

**TaskDetailsInteractor**:
- Receives Task from Builder
- Binds Task to presenter.task Binder
- No transformation (pass-through)

**TaskDetailsViewController**:
- Receives Task via Binder
- Updates ViewState.task
- ViewState → SwiftUI View

**TaskDetailsView**:
- Observes ViewState.task
- Displays all Task properties
- Formats distance, travel time, visit time for display

---

## No Persistence

**None required** - TaskDetails displays data from Task parameter, no storage needed.

---

## Validation

### Task Validation

- Task validation handled by DailyPlannerWorker (source of truth)
- TaskDetails RIB assumes valid Task is passed
- Defensive: Displays placeholder for missing fields (photo, address, etc.)

---

## Error States

1. **Missing Task data**: Display placeholder content for missing fields
2. **Invalid Task**: TaskDetails RIB assumes valid Task (validation at source)
3. **Image load failure**: AsyncImage shows error placeholder
4. **Location unavailable**: Distance shows "Distance unavailable" (same as home task list)

---

## Future Enhancements (Out of Scope)

- Real-time Task updates in detail view
- Task editing capabilities
- Additional task metadata
- Task history/notes
