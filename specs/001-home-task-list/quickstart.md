# Quick Start Guide: Home Task List Implementation

**Feature**: 001-home-task-list  
**Date**: 2025-01-27  
**Phase**: 1 (Design)

## Implementation Sequence

Follow this order to implement the feature incrementally, ensuring compilation at each step.

### Step 1: Create Data Models

**Files**: `Models/Task.swift`, `Models/TaskStatus.swift`

1. Create `TaskStatus` enum with all status cases
2. Create `Task` struct with all properties
3. Make `Task` conform to `Identifiable` and `Equatable`
4. Add computed properties for distance and travel time (can be mutable `var`)

**Validation**: Compiles, no dependencies on Workers yet

---

### Step 2: Create LocationServiceWorker

**File**: `Workers/LocationServiceWorker.swift`

1. Create `LocationServiceWorking` protocol extending `Working`
   - `var currentLocation: Observable<CLLocation?> { get }`
   - `var authorizationStatus: Observable<CLAuthorizationStatus> { get }`
2. Create `LocationServiceWorker` class extending `Worker`
3. Implement `CLLocationManagerDelegate`
4. Request "When In Use" permission in `didStart()`
5. Start location updates with distance filter (100m)
6. Expose Rx streams via BehaviorSubject/ReplayRelay

**Key Code Pattern**:
```swift
class LocationServiceWorker: Worker, LocationServiceWorking, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let currentLocationSubject = BehaviorSubject<CLLocation?>(value: nil)
    
    var currentLocation: Observable<CLLocation?> {
        currentLocationSubject.asObservable()
    }
    
    override func didStart(_ interactorScope: InteractorScope) {
        super.didStart(interactorScope)
        locationManager.delegate = self
        locationManager.distanceFilter = 100
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        // Start updates after permission granted
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocationSubject.onNext(locations.last)
    }
}
```

**Validation**: Compiles, can be instantiated (but not tested without permission)

---

### Step 3: Create DailyPlannerWorker

**File**: `Workers/DailyPlannerWorker.swift`

1. Create `DailyPlannerWorking` protocol extending `Working`
   - `var tasks: Observable<[Task]> { get }`
2. Create `DailyPlannerWorker` class extending `Worker`
3. Add mock data array (5-10 tasks)
4. Inject `LocationServiceWorking` dependency
5. In `didStart()`, combine mock tasks with location stream
6. Map to update distances and travel times
7. Sort by `visitingOrder`
8. Expose tasks stream

**Key Code Pattern**:
```swift
class DailyPlannerWorker: Worker, DailyPlannerWorking {
    private let locationService: LocationServiceWorking
    private let tasksSubject = BehaviorSubject<[Task]>(value: [])
    
    var tasks: Observable<[Task]> {
        tasksSubject.asObservable()
    }
    
    init(locationService: LocationServiceWorking) {
        self.locationService = locationService
        super.init()
    }
    
    override func didStart(_ interactorScope: InteractorScope) {
        super.didStart(interactorScope)
        
        Observable.combineLatest(
            Observable.just(mockTasks),
            locationService.currentLocation
        )
        .map { [weak self] tasks, location in
            tasks.map { task in
                var updated = task
                updated.distanceFromCurrentLocation = self?.calculateDistance(from: location, to: task.location)
                updated.estimatedTravelTime = self?.estimateTravelTime(distance: updated.distanceFromCurrentLocation ?? 0)
                return updated
            }
            .sorted { $0.visitingOrder < $1.visitingOrder }
        }
        .bind(to: tasksSubject)
        .disposeOnStop(self)
    }
    
    private func calculateDistance(from location: CLLocation?, to coordinate: CLLocationCoordinate2D) -> Double? {
        guard let location else { return nil }
        let taskLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return location.distance(from: taskLocation)
    }
    
    private func estimateTravelTime(distance: Double) -> TimeInterval {
        let averageSpeedKmh = 50.0
        let averageSpeedMs = averageSpeedKmh * 1000 / 3600
        return distance / averageSpeedMs
    }
}
```

**Validation**: Compiles, Workers can be instantiated

---

### Step 4: Wire Workers to RootComponent

**File**: `RIBs/Root/RootBuilder.swift` (update RootComponent)

1. Add `locationServiceWorker` lazy property to `RootComponent`
2. Add `dailyPlannerWorker` lazy property (depends on locationServiceWorker)
3. Ensure Workers are created before Main RIB is built

**Key Code Pattern**:
```swift
final class RootComponent: Component<RootDependency> {
    // ... existing properties
    
    lazy var locationServiceWorker: LocationServiceWorking = {
        LocationServiceWorker()
    }()
    
    lazy var dailyPlannerWorker: DailyPlannerWorking = {
        DailyPlannerWorker(locationService: locationServiceWorker)
    }()
}
```

**Validation**: Compiles, Workers available in RootComponent

---

### Step 5: Wire DailyPlannerWorker to MainDependency

**File**: `RIBs/Root/RootBuilder.swift` (update extension)

1. Extend `RootComponent` to conform to `MainDependency`
2. Add `dailyPlannerWorker` property to `MainDependency` protocol
3. Return `dailyPlannerWorker` from RootComponent

**Key Code Pattern**:
```swift
/// sourcery: CreateMock
protocol MainDependency: Dependency {
    var themeProvider: ThemeProviding { get }
    var dailyPlannerWorker: DailyPlannerWorking { get } // NEW
}

extension RootComponent: MainDependency {
    var dailyPlannerWorker: DailyPlannerWorking { _dailyPlannerWorker }
}
```

**Validation**: Compiles, MainDependency includes dailyPlannerWorker

---

### Step 6: Update MainComponent and MainBuilder

**File**: `RIBs/Main/MainBuilder.swift`

1. Add `dailyPlannerWorker` to `MainComponent`
2. Extract `dailyPlannerWorker` from component in `MainBuilder`
3. Pass to `MainInteractor` initializer

**Key Code Pattern**:
```swift
final class MainComponent: Component<MainDependency> {
    var themeProvider: ThemeProviding { dependency.themeProvider }
    var dailyPlannerWorker: DailyPlannerWorking { dependency.dailyPlannerWorker } // NEW
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {
    func build(...) -> MainRouting {
        let component = MainComponent(dependency: dependency)
        
        let viewController = MainViewController(...)
        
        let interactor = MainInteractor(
            dailyPlannerWorker: component.dailyPlannerWorker, // NEW
            presenter: viewController)
        
        // ... rest of builder
    }
}
```

**Validation**: Compiles, MainInteractor receives DailyPlannerWorker

---

### Step 7: Update MainInteractor

**File**: `RIBs/Main/MainInteractor.swift`

1. Add `dailyPlannerWorker: DailyPlannerWorking` property
2. Update initializer to accept DailyPlannerWorker
3. In `didBecomeActive()`, subscribe to `dailyPlannerWorker.tasks`
4. Bind tasks stream to `presenter.tasks` Binder
5. Use `.disposeOnDeactivate(interactor: self)`

**Key Code Pattern**:
```swift
final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable {
    private let dailyPlannerWorker: DailyPlannerWorking
    
    init(dailyPlannerWorker: DailyPlannerWorking, presenter: MainPresentable) {
        self.dailyPlannerWorker = dailyPlannerWorker
        super.init(presenter: presenter)
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        dailyPlannerWorker.tasks
            .bind(to: presenter.tasks)
            .disposeOnDeactivate(interactor: self)
    }
}
```

**Validation**: Compiles, Interactor subscribes to tasks stream

---

### Step 8: Update MainPresentable Protocol

**File**: `RIBs/Main/MainInteractor.swift` (protocol definition)

1. Add `var tasks: Binder<[Task]> { get }` to `MainPresentable`
2. Add `var isLoading: Binder<Bool> { get }` (optional, for loading state)

**Key Code Pattern**:
```swift
protocol MainPresentable: Presentable {
    var tasks: Binder<[Task]> { get }
    var isLoading: Binder<Bool> { get } // Optional
}
```

**Validation**: Compiles, Presentable protocol updated

---

### Step 9: Update MainViewController

**File**: `RIBs/Main/MainView.swift`

1. Add `tasks` Binder implementation (binds to `viewState.tasks`)
2. Add `isLoading` Binder if needed
3. Update `MainViewState` to include `@Published var tasks: [Task] = []`

**Key Code Pattern**:
```swift
final class MainViewController: UIHostingController<MainView>, MainPresentable, MainViewControllable {
    private let viewState = MainViewState()
    
    var tasks: Binder<[Task]> {
        Binder(viewState) { state, tasks in
            state.tasks = tasks
        }
    }
}
```

**Validation**: Compiles, Presentable implements Binders

---

### Step 10: Update MainView UI

**File**: `RIBs/Main/MainView.swift`

1. Create `TaskCard` SwiftUI component
2. Update `MainView` to display task list (LazyVStack in ScrollView)
3. Use `AsyncImage` for task photos
4. Display all task information (name, address, hours, distance, time, status)
5. Add empty state view
6. Style using semantic fonts and colors from ThemeProvider

**Key Code Pattern**:
```swift
struct MainView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                if viewState.tasks.isEmpty {
                    EmptyStateView()
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewState.tasks) { task in
                            TaskCard(task: task, themeProvider: themeProvider)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct TaskCard: View {
    let task: Task
    let themeProvider: ThemeProviding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image
            AsyncImage(url: task.photoURL) { phase in
                // ... handle phases
            }
            
            // Venue name, address, etc.
            Text(task.venueName)
                .font(themeProvider.font(.headline))
            
            // ... more UI
        }
    }
}
```

**Validation**: Compiles, UI displays task list

---

### Step 11: Start Workers in RootInteractor

**File**: `RIBs/Root/RootInteractor.swift`

1. In `didBecomeActive()`, start both Workers
2. Use `worker.start(self)` to bind Worker lifecycle to Interactor

**Key Code Pattern**:
```swift
final class RootInteractor: Interactor, RootInteractable {
    private let locationServiceWorker: LocationServiceWorking
    private let dailyPlannerWorker: DailyPlannerWorking
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        locationServiceWorker.start(self)
        dailyPlannerWorker.start(self)
    }
}
```

**Validation**: Compiles, Workers start when Root RIB becomes active

---

### Step 12: Add Localization Strings

**File**: `Localizable.xcstrings`

1. Add strings for:
   - Empty state message
   - Distance unavailable
   - Status labels
   - Time format helpers

**Validation**: Compiles, strings available via `localizable:` key

---

## Testing Checklist

After each step, verify:
- [ ] Code compiles without errors
- [ ] No warnings (address if critical)
- [ ] Workers can be instantiated
- [ ] Rx streams emit values (test in debugger)
- [ ] UI updates when data changes

## Common Pitfalls

1. **Forgetting to start Workers**: Workers must be started in Interactor's `didBecomeActive()`
2. **Rx lifecycle**: Always use `.disposeOnDeactivate(interactor:)` or `.disposeOnStop(self)`
3. **Location permission**: Request permission before starting location updates
4. **Thread safety**: Rx streams should emit on main thread for UI updates
5. **Nil handling**: Always handle `nil` location gracefully in distance calculations

## Next Steps

After implementation:
1. Run app in simulator
2. Grant location permission when prompted
3. Verify task list displays
4. Simulate location changes (Debug → Location → Custom Location)
5. Verify distance updates
