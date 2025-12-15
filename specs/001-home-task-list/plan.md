# Implementation Plan: Home Task List

**Branch**: `001-home-task-list` | **Date**: 2025-01-27 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-home-task-list/spec.md`

**Note**: This template is filled in by the `Plan` command.

## Summary

This feature implements a home screen displaying today's tasks (shops to visit) for field agents. The implementation includes:

1. **Main RIB Enhancement**: Update the existing Main RIB to display a scrollable list of task cards
2. **DailyPlanner Worker**: Prototype service providing Rx stream of today's tasks with mock data
3. **LocationService Worker**: Service providing real-time location updates via Rx stream
4. **Data Flow**: LocationService → DailyPlanner (updates distances) → Main RIB (displays tasks)
5. **UI Components**: Task cards with venue info, photos (Shutterstock), async image loading, distance/time display

The feature uses mock data for tasks, visiting order, and travel time calculations. Images are loaded asynchronously from Shutterstock without additional caching.

## Technical Context

**Language/Version**: Swift 5.9+
**Primary Dependencies**: 
- RIBs framework (Uber RIBs)
- RxSwift/RxRelay for reactive data streams
- SwiftUI for UI implementation
- CoreLocation for location services
- AsyncImage (SwiftUI) for image loading

**Storage**: Mock data in-memory (no persistence required per spec)
**Testing**: XCTest (unit tests for Workers and Interactor logic)
**Target Platform**: iOS 15+
**Project Type**: Mobile (iOS native app)
**Performance Goals**: 
- Task list loads within 2 seconds (SC-001)
- Distance updates within 30 seconds of location change > 100m (SC-003)
- Smooth scrolling with async image loading

**Constraints**: 
- No additional image caching (per user requirements)
- Mock data only (no backend integration)
- Location updates must be throttled to prevent excessive recalculations

**Scale/Scope**: 
- Single screen (Main RIB home screen)
- 2 Workers (DailyPlanner, LocationService)
- Task list with 5-20 tasks per day (estimated)

## Constitution Check

_GATE: Must pass before Phase 0 research. Re-check after Phase 1 design._

### Module Placement
✅ **PASS**: All code lives in `iOS/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/`
- Main RIB update: `RIBs/Main/`
- Workers: `Workers/DailyPlannerWorker.swift`, `Workers/LocationServiceWorker.swift`
- Models: `Models/Task.swift`, `Models/Location.swift` (if needed as separate files)

### RIB Architecture
✅ **PASS**: 
- Main RIB is view-having, uses Presenter pattern
- Workers follow RIBs Worker pattern with Rx streams
- No new RIBs created (updating existing Main RIB)

### Dependency Injection
✅ **PASS**:
- Workers created in RootComponent (shared services)
- Workers exposed via protocols (`DailyPlannerWorking`, `LocationServiceWorking`)
- Concrete protocols injected into MainInteractor (not `*Dependency`)

### SwiftUI Usage
✅ **PASS**: Main RIB already uses SwiftUI (`MainView`), will extend existing implementation

### Protocol Organization
✅ **PASS**: Following existing patterns:
- Worker protocols in Worker files
- Presentable in Interactor file
- No new RIB protocols needed (updating existing Main RIB)

## Project Structure

### Documentation (this feature)

```text
specs/001-home-task-list/
├── plan.md              # This file (Plan phase output)
├── research.md          # Phase 0 output (Plan phase output)
├── data-model.md        # Phase 1 output (Plan phase output)
├── quickstart.md        # Phase 1 output (Plan phase output)
└── tasks.md             # Phase 2 output (Tasks phase output - NOT created by Plan)
```

### Source Code (repository root)

```text
src-ios/
├── Libraries/
│   └── FieldAgentTrackerMain/
│       └── Sources/
│           └── FieldAgentTrackerMain/
│               ├── RIBs/
│               │   └── Main/
│               │       ├── MainBuilder.swift          # Updated: inject Workers
│               │       ├── MainInteractor.swift       # Updated: subscribe to DailyPlanner stream
│               │       ├── MainRouter.swift          # No changes
│               │       └── MainView.swift             # Updated: Task list UI
│               ├── Workers/
│               │   ├── DailyPlannerWorker.swift      # NEW: Task list provider
│               │   └── LocationServiceWorker.swift   # NEW: Location updates
│               ├── Models/
│               │   ├── Task.swift                     # NEW: Task entity
│               │   └── TaskStatus.swift               # NEW: Task status enum
│               └── Localizable.xcstrings               # Updated: Add task list strings
└── App/                                                 # No changes
```

**Structure Decision**: 
- All feature code in existing `FieldAgentTrackerMain` SPM module
- Workers added to `Workers/` directory following existing pattern
- Models added to `Models/` directory (or inline if simple)
- Main RIB updated in place (no new RIBs)

## Complexity Tracking

> **No violations identified - all patterns follow established architecture**

## Phase 0: Research & Decisions

See [research.md](./research.md) for detailed research findings.

### Key Decisions

1. **Image Loading**: Use SwiftUI `AsyncImage` with Shutterstock URLs (no custom caching per requirements)
2. **Location Updates**: Use CoreLocation with distance filter (100m) and desired accuracy (kCLLocationAccuracyHundredMeters) to throttle updates
3. **Distance Calculation**: Use `CLLocation.distance(from:)` for geographic distance
4. **Mock Data**: In-memory arrays in DailyPlannerWorker with realistic shop data
5. **Data Flow Architecture**: 
   - LocationServiceWorker exposes `currentLocation: Observable<CLLocation?>`
   - DailyPlannerWorker subscribes to LocationServiceWorker location stream
   - DailyPlannerWorker exposes `tasks: Observable<[Task]>` with updated distances
   - MainInteractor subscribes to DailyPlannerWorker tasks stream

## Phase 1: Design & Contracts

### Data Model

See [data-model.md](./data-model.md) for complete data model specification.

**Key Entities**:

1. **Task**: Represents a shop visit
   - `id: UUID`
   - `venueName: String`
   - `address: String`
   - `openingHours: String`
   - `plannedVisitTime: Date`
   - `status: TaskStatus`
   - `visitingOrder: Int`
   - `photoURL: URL` (Shutterstock)
   - `location: CLLocationCoordinate2D`
   - `distanceFromCurrentLocation: Double?` (computed, meters)
   - `estimatedTravelTime: TimeInterval?` (computed, seconds)

2. **TaskStatus**: Enum
   - `.planned`
   - `.enRoute`
   - `.inProgress`
   - `.done`
   - `.cancelled`
   - `.cantComplete`

### Worker Contracts

#### DailyPlannerWorking Protocol

```swift
protocol DailyPlannerWorking: Working {
    var tasks: Observable<[Task]> { get }
}
```

**Responsibilities**:
- Provide Rx stream of today's tasks ordered by visiting order
- Subscribe to LocationServiceWorker for location updates
- Recalculate distances when location changes
- Use mock data for task list

#### LocationServiceWorking Protocol

```swift
protocol LocationServiceWorking: Working {
    var currentLocation: Observable<CLLocation?> { get }
    var authorizationStatus: Observable<CLAuthorizationStatus> { get }
}
```

**Responsibilities**:
- Request location permissions
- Provide Rx stream of current location
- Throttle location updates (100m distance filter)
- Handle permission denial gracefully

### RIB Contracts

#### MainPresentable (Updated)

```swift
protocol MainPresentable: Presentable {
    // Interactor → UI
    var tasks: Binder<[Task]> { get }
    var isLoading: Binder<Bool> { get }
    
    // UI → Interactor (none required for this feature)
}
```

### Integration Points

1. **RootComponent**: Creates and owns both Workers
   ```swift
   lazy var dailyPlannerWorker: DailyPlannerWorking = {
       DailyPlannerWorker(locationService: locationServiceWorker)
   }()
   
   lazy var locationServiceWorker: LocationServiceWorking = {
       LocationServiceWorker()
   }()
   ```

2. **MainComponent**: Receives Workers from RootComponent via MainDependency
   ```swift
   extension RootComponent: MainDependency {
       var dailyPlannerWorker: DailyPlannerWorking { ... }
   }
   ```

3. **MainBuilder**: Extracts Workers from Component, injects into Interactor
   ```swift
   let interactor = MainInteractor(
       dailyPlannerWorker: component.dailyPlannerWorker,
       presenter: viewController)
   ```

4. **MainInteractor**: Subscribes to DailyPlannerWorker tasks stream
   ```swift
   override func didBecomeActive() {
       super.didBecomeActive()
       
       dailyPlannerWorker.tasks
           .bind(to: presenter.tasks)
           .disposeOnDeactivate(interactor: self)
   }
   ```

### UI Design

#### MainViewState (Updated)

```swift
final class MainViewState: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var isLoading: Bool = false
}
```

#### MainView (Updated)

- ScrollView with LazyVStack for task cards
- TaskCard SwiftUI component displaying:
  - Large image (AsyncImage from Shutterstock URL)
  - Venue name (headline font)
  - Address (bodyRegular font)
  - Opening hours (subheadRegular font)
  - Distance and travel time (bodyMedium font, highlighted)
  - Planned visit time (footnoteRegular font)
  - Status badge (visual indicator with color)
- Empty state view when no tasks
- Loading state during initial load

### Quick Start Guide

See [quickstart.md](./quickstart.md) for implementation sequence and key code patterns.

## Phase 2: Implementation Tasks

_This section will be populated by the Tasks phase. Not created during Plan phase._

## Notes

- LocationServiceWorker should request "When In Use" location permission
- DailyPlannerWorker calculates distance using `CLLocation.distance(from:)` when location updates
- Mock data includes 5-10 sample tasks with Shutterstock image URLs
- Task status is read-only in this feature (managed by system, not user-editable)
- Distance updates are throttled by CoreLocation distance filter (100m) to prevent excessive recalculations
- If location permission denied, distance shows as `nil` and UI displays "Distance unavailable"
