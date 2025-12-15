# Data Model: Home Task List

**Feature**: 001-home-task-list  
**Date**: 2025-01-27  
**Phase**: 1 (Design)

## Entities

### Task

Represents a shop visit scheduled for today.

**Location**: `Models/Task.swift` (or inline in DailyPlannerWorker if simple)

**Properties**:

```swift
struct Task: Identifiable, Equatable {
    let id: UUID
    let venueName: String
    let address: String
    let openingHours: String
    let plannedVisitTime: Date
    let status: TaskStatus
    let visitingOrder: Int
    let photoURL: URL
    let location: CLLocationCoordinate2D
    
    // Computed/updated properties
    var distanceFromCurrentLocation: Double? // meters, nil if location unavailable
    var estimatedTravelTime: TimeInterval? // seconds, nil if distance unavailable
}
```

**Validation Rules**:
- `visitingOrder` must be unique within today's tasks
- `plannedVisitTime` should be today's date (validation in DailyPlannerWorker)
- `photoURL` must be valid URL (Shutterstock)
- `location` must be valid coordinates (latitude: -90 to 90, longitude: -180 to 180)

**Relationships**:
- Belongs to today's schedule (filtered by DailyPlannerWorker)
- Has one status (TaskStatus enum)
- Has one visiting order position (Int)

**State Transitions**:
- Status is read-only in this feature (managed by system, not user-editable)
- Status transitions: Planned → En route → In progress → Done (or Cancelled/CantComplete)

---

### TaskStatus

Enumeration of possible task completion states.

**Location**: `Models/TaskStatus.swift` (or inline in Task.swift)

**Values**:

```swift
enum TaskStatus: String, CaseIterable, Equatable {
    case planned = "Planned"
    case enRoute = "En route"
    case inProgress = "In progress"
    case done = "Done"
    case cancelled = "Cancelled"
    case cantComplete = "Can't complete"
}
```

**Display**:
- Used in UI to show status badge/indicator
- Each status may have associated color (planned: blue, done: green, cancelled: red, etc.)

---

### Location (Implicit)

Represents a geographic point. Uses CoreLocation's `CLLocationCoordinate2D` and `CLLocation`.

**No separate model needed** - using CoreLocation types:
- `CLLocationCoordinate2D` for task locations (latitude, longitude)
- `CLLocation` for current user location (includes altitude, accuracy, timestamp)

**Usage**:
- Task locations stored as `CLLocationCoordinate2D` in Task model
- Current location provided by LocationServiceWorker as `CLLocation?`
- Distance calculated using `CLLocation.distance(from:)`

---

## Data Flow

### Streams

1. **LocationServiceWorker.currentLocation**: `Observable<CLLocation?>`
   - Emits current user location
   - Updates when location changes (>100m movement)
   - Emits `nil` when location unavailable (permission denied, GPS off)

2. **LocationServiceWorker.authorizationStatus**: `Observable<CLAuthorizationStatus>`
   - Emits location permission status
   - Used for UI feedback (show permission prompt if needed)

3. **DailyPlannerWorker.tasks**: `Observable<[Task]>`
   - Emits array of today's tasks
   - Ordered by `visitingOrder`
   - Distances updated when location changes
   - Emits empty array if no tasks for today

### Data Transformations

**LocationServiceWorker**:
- Raw GPS data → `CLLocation` objects
- Throttled by distance filter (100m)
- Wrapped in Rx Observable

**DailyPlannerWorker**:
- Mock task data → Task array
- Combines with location stream: `combineLatest(mockTasks, currentLocation)`
- Maps to update distances: `tasks.map { updateDistance($0, from: location) }`
- Sorts by `visitingOrder`
- Filters to today's date (if needed)

**MainInteractor**:
- Tasks stream → Binder to Presenter
- No transformation (pass-through)

**MainViewController**:
- Tasks array → ViewState.tasks
- ViewState → SwiftUI View

---

## Mock Data Structure

**Location**: In-memory array in `DailyPlannerWorker`

**Sample Data** (5-10 tasks):

```swift
private let mockTasks: [Task] = [
    Task(
        id: UUID(),
        venueName: "Downtown Coffee Shop",
        address: "123 Main Street, City, State 12345",
        openingHours: "7:00 AM - 6:00 PM",
        plannedVisitTime: Date().addingTimeInterval(3600), // 1 hour from now
        status: .planned,
        visitingOrder: 1,
        photoURL: URL(string: "https://example.shutterstock.com/image-1.jpg")!,
        location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        distanceFromCurrentLocation: nil, // Updated by location stream
        estimatedTravelTime: nil
    ),
    // ... more tasks
]
```

**Requirements**:
- Realistic shop names
- Valid addresses
- Opening hours in readable format
- Mix of statuses (mostly .planned, some .done for testing)
- Sequential visiting order (1, 2, 3, ...)
- Valid Shutterstock image URLs (or placeholder URLs)
- Valid coordinates (use real city coordinates)

---

## Persistence

**None required** - mock data is in-memory only.

Future enhancement: Replace mock data with API/backend integration.

---

## Validation

### Task Validation

- Visiting order uniqueness: Checked when building mock data
- Date validation: Filter to today's date in DailyPlannerWorker
- URL validation: Use `URL(string:)` initializer (returns nil if invalid)

### Location Validation

- Coordinate bounds: CoreLocation handles invalid coordinates
- Permission check: LocationServiceWorker checks authorization status
- Nil handling: UI displays "Distance unavailable" when location is nil

---

## Error States

1. **No tasks for today**: Empty array → Empty state UI
2. **Location permission denied**: `currentLocation` emits `nil` → Distance shows "unavailable"
3. **GPS unavailable**: `currentLocation` emits `nil` → Distance shows "unavailable"
4. **Image load failure**: AsyncImage shows error placeholder
5. **Invalid task data**: DailyPlannerWorker filters out invalid tasks (defensive)

---

## Future Enhancements (Out of Scope)

- Task persistence (CoreData/backend)
- Real routing API integration
- Image caching
- Task status updates (user actions)
- Multi-day task lists
- Task filtering/searching
