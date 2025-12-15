# Research & Technical Decisions: Home Task List

**Feature**: 001-home-task-list  
**Date**: 2025-01-27  
**Phase**: 0 (Research)

## Research Questions

### 1. Image Loading Strategy

**Question**: How to load Shutterstock images asynchronously without additional caching?

**Research**:
- SwiftUI provides `AsyncImage` view that handles async loading automatically
- `AsyncImage` uses URLSession internally for network requests
- No built-in caching, but acceptable for prototype (per requirements)
- Can provide placeholder and error states

**Decision**: Use SwiftUI `AsyncImage` with Shutterstock URLs directly
- **Rationale**: 
  - Native SwiftUI solution, no additional dependencies
  - Handles async loading automatically
  - Supports placeholder and error states
  - Meets requirement of "no additional caching"
- **Alternatives Considered**:
  - SDWebImageSwiftUI: Rejected (adds dependency, includes caching)
  - Custom URLSession + Image: Rejected (more code, AsyncImage is sufficient)

**Implementation**:
```swift
AsyncImage(url: task.photoURL) { phase in
    switch phase {
    case .empty:
        ProgressView()
    case .success(let image):
        image.resizable()
    case .failure:
        Image(systemName: "photo")
    @unknown default:
        EmptyView()
    }
}
```

---

### 2. Location Service Implementation

**Question**: How to implement real-time location updates with proper throttling?

**Research**:
- CoreLocation `CLLocationManager` provides location updates
- `distanceFilter` property throttles updates (only fires when moved > threshold)
- `desiredAccuracy` controls GPS precision vs battery usage
- `requestWhenInUseAuthorization()` for location permission
- RxSwift can wrap CLLocationManager delegate callbacks

**Decision**: Use CoreLocation with RxSwift wrapper
- **Rationale**:
  - Native iOS solution, no third-party dependencies
  - `distanceFilter: 100` meters matches spec requirement (updates on >100m movement)
  - `desiredAccuracy: kCLLocationAccuracyHundredMeters` balances accuracy and battery
  - RxSwift integration follows existing Worker pattern
- **Alternatives Considered**:
  - RxCoreLocation library: Rejected (adds dependency, CLLocationManager is sufficient)
  - Timer-based polling: Rejected (inefficient, CoreLocation is better)

**Implementation Pattern**:
```swift
class LocationServiceWorker: Worker, LocationServiceWorking {
    private let locationManager = CLLocationManager()
    private let currentLocationSubject = BehaviorSubject<CLLocation?>(value: nil)
    
    override func didStart(_ interactorScope: InteractorScope) {
        locationManager.delegate = self
        locationManager.distanceFilter = 100 // meters
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
```

---

### 3. Distance Calculation Method

**Question**: How to calculate distance between current location and task locations?

**Research**:
- `CLLocation.distance(from:)` calculates great-circle distance (Haversine formula)
- Returns distance in meters
- Accurate for distances up to ~1000km
- No external dependencies needed

**Decision**: Use `CLLocation.distance(from:)` for distance calculations
- **Rationale**:
  - Native CoreLocation method
  - Accurate for field agent use case (local distances)
  - Simple API, no additional dependencies
- **Alternatives Considered**:
  - MapKit routing: Rejected (overkill for distance-only, requires network)
  - Custom Haversine: Rejected (unnecessary, CLLocation provides this)

**Implementation**:
```swift
func calculateDistance(from currentLocation: CLLocation?, to taskLocation: CLLocationCoordinate2D) -> Double? {
    guard let currentLocation else { return nil }
    let taskLocationObj = CLLocation(latitude: taskLocation.latitude, longitude: taskLocation.longitude)
    return currentLocation.distance(from: taskLocationObj)
}
```

---

### 4. Travel Time Estimation

**Question**: How to estimate travel time from distance (mock data requirement)?

**Research**:
- Spec requires mock data for travel time
- Simple approach: assume average speed (e.g., 50 km/h for urban driving)
- Formula: `time = distance / speed`
- Can be enhanced later with real routing API

**Decision**: Use simple speed-based calculation for mock data
- **Rationale**:
  - Meets requirement of "mock data for travel time"
  - Simple implementation
  - Can be replaced with real routing later
- **Alternatives Considered**:
  - MKDirections API: Rejected (requires network, spec says mock data)
  - Fixed time per task: Rejected (distance-based is more realistic)

**Implementation**:
```swift
func estimateTravelTime(distance: Double) -> TimeInterval {
    let averageSpeedKmh = 50.0 // km/h
    let averageSpeedMs = averageSpeedKmh * 1000 / 3600 // m/s
    return distance / averageSpeedMs // seconds
}
```

---

### 5. Data Flow Architecture

**Question**: How should location updates flow to task list updates?

**Research**:
- LocationServiceWorker exposes location stream
- DailyPlannerWorker needs location to calculate distances
- DailyPlannerWorker exposes tasks stream with updated distances
- MainInteractor subscribes to tasks stream
- RxSwift `combineLatest` or `withLatestFrom` can combine streams

**Decision**: LocationServiceWorker → DailyPlannerWorker → MainInteractor
- **Rationale**:
  - Follows RIBs Worker pattern (Workers own business logic)
  - Single source of truth (DailyPlannerWorker owns task list)
  - Reactive updates via Rx streams
  - Clear separation of concerns
- **Alternatives Considered**:
  - MainInteractor subscribes to both: Rejected (violates separation, DailyPlanner should own distance calculation)
  - LocationServiceWorker directly updates tasks: Rejected (violates single responsibility)

**Implementation Pattern**:
```swift
// LocationServiceWorker
var currentLocation: Observable<CLLocation?> { currentLocationSubject.asObservable() }

// DailyPlannerWorker
init(locationService: LocationServiceWorking) {
    self.locationService = locationService
}

override func didStart(_ interactorScope: InteractorScope) {
    Observable.combineLatest(
        mockTasksSubject,
        locationService.currentLocation
    )
    .map { tasks, location in
        tasks.map { task in
            var updated = task
            updated.distanceFromCurrentLocation = calculateDistance(from: location, to: task.location)
            updated.estimatedTravelTime = estimateTravelTime(distance: updated.distanceFromCurrentLocation ?? 0)
            return updated
        }
    }
    .bind(to: tasksSubject)
    .disposeOnStop(self)
}
```

---

### 6. Mock Data Structure

**Question**: What mock data structure should be used for tasks?

**Research**:
- Need realistic shop names, addresses, opening hours
- Need Shutterstock image URLs (public API or sample URLs)
- Need coordinates for distance calculation
- Need visiting order for sorting
- Need various statuses for testing

**Decision**: In-memory array in DailyPlannerWorker
- **Rationale**:
  - Simple, no persistence needed (per spec: mock data)
  - Easy to modify for testing
  - Can be replaced with real API later
- **Alternatives Considered**:
  - JSON file: Rejected (adds file I/O, in-memory is simpler for prototype)
  - CoreData: Rejected (overkill for mock data)

**Mock Data Includes**:
- 5-10 sample tasks
- Realistic shop names (e.g., "Downtown Coffee Shop", "Main Street Pharmacy")
- Real addresses in target city
- Opening hours (e.g., "9:00 AM - 5:00 PM")
- Shutterstock image URLs (sample or placeholder URLs)
- Coordinates (latitude/longitude)
- Visiting order (1, 2, 3, ...)
- Mix of task statuses

---

### 7. Permission Handling

**Question**: How to handle location permission denial gracefully?

**Research**:
- `CLAuthorizationStatus` enum provides permission states
- `.notDetermined`: Permission not requested yet
- `.denied` or `.restricted`: Permission denied
- Need to show fallback UI when permission denied
- Should request permission on first use

**Decision**: Request "When In Use" permission, handle denial with fallback
- **Rationale**:
  - "When In Use" is appropriate for field agent app
  - Graceful degradation: show tasks without distance when denied
  - Follows iOS best practices
- **Alternatives Considered**:
  - "Always" permission: Rejected (not needed, "When In Use" is sufficient)
  - No permission request: Rejected (distance feature won't work)

**Implementation**:
```swift
var authorizationStatus: Observable<CLAuthorizationStatus> {
    authorizationStatusSubject.asObservable()
}

// In DailyPlannerWorker, handle nil location:
.map { tasks, location in
    tasks.map { task in
        var updated = task
        if let location = location {
            updated.distanceFromCurrentLocation = calculateDistance(from: location, to: task.location)
        } else {
            updated.distanceFromCurrentLocation = nil // Shows "Distance unavailable"
        }
        return updated
    }
}
```

---

## Summary of Decisions

| Decision Area | Choice | Rationale |
|--------------|--------|-----------|
| Image Loading | SwiftUI AsyncImage | Native, no caching, handles async automatically |
| Location Service | CoreLocation + RxSwift | Native, proper throttling, follows Worker pattern |
| Distance Calculation | CLLocation.distance(from:) | Native, accurate, simple API |
| Travel Time | Speed-based mock calculation | Meets mock data requirement, simple |
| Data Flow | LocationService → DailyPlanner → Main | Clear separation, reactive streams |
| Mock Data | In-memory array | Simple, easy to modify, no persistence needed |
| Permissions | "When In Use" with graceful fallback | Appropriate for use case, handles denial |

## Open Questions Resolved

✅ All research questions resolved. No [NEEDS CLARIFICATION] markers remain.

## References

- [SwiftUI AsyncImage Documentation](https://developer.apple.com/documentation/swiftui/asyncimage)
- [CoreLocation CLLocationManager](https://developer.apple.com/documentation/corelocation/cllocationmanager)
- [RIBs Worker Pattern](knowledge/ios-RIBs.md#worker-pattern-business-logic)
- [RxSwift Observable Patterns](https://github.com/ReactiveX/RxSwift)
