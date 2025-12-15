// (c) Copyright PopAppFactory 2024

import Foundation
import RIBs
import RxSwift
import RxRelay
import CoreLocation

/// sourcery: CreateMock
protocol DailyPlannerWorking: Working {
  var tasks: Observable<[Task]> { get }
}

final class DailyPlannerWorker: Worker, DailyPlannerWorking {
  
  var tasks: Observable<[Task]> {
    return tasksSubject.asObservable()
  }
  
  private let locationService: LocationServiceWorking
  private let tasksSubject = BehaviorSubject<[Task]>(value: [])
  
  init(locationService: LocationServiceWorking) {
    self.locationService = locationService
    super.init()
  }
  
  override func didStart(_ interactorScope: any InteractorScope) {
    super.didStart(interactorScope)
    
    // Combine mock tasks with location updates
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
  
  // MARK: - Distance Calculation
  
  private func calculateDistance(from location: CLLocation?, to coordinate: CLLocationCoordinate2D) -> Double? {
    guard let location else { return nil }
    let taskLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    return location.distance(from: taskLocation)
  }
  
  private func estimateTravelTime(distance: Double) -> TimeInterval? {
    guard distance > 0 else { return nil }
    let averageSpeedKmh = 50.0 // km/h
    let averageSpeedMs = averageSpeedKmh * 1000 / 3600 // m/s
    return distance / averageSpeedMs // seconds
  }
  
  // MARK: - Mock Data
  
  private var mockTasks: [Task] {
    let now = Date()
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: now)
    
    return [
      Task(
        id: UUID(),
        venueName: "Downtown Coffee Shop",
        address: "123 Main Street, San Francisco, CA 94102",
        openingHours: "7:00 AM - 6:00 PM",
        plannedVisitTime: calendar.date(byAdding: .hour, value: 1, to: today) ?? now,
        status: .planned,
        visitingOrder: 1,
        photoURL: URL(string: "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&q=80")!,
        location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        distanceFromCurrentLocation: nil,
        estimatedTravelTime: nil
      ),
      Task(
        id: UUID(),
        venueName: "Main Street Pharmacy",
        address: "456 Market Street, San Francisco, CA 94103",
        openingHours: "9:00 AM - 5:00 PM",
        plannedVisitTime: calendar.date(byAdding: .hour, value: 3, to: today) ?? now,
        status: .planned,
        visitingOrder: 2,
        photoURL: URL(string: "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&q=80")!,
        location: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094),
        distanceFromCurrentLocation: nil,
        estimatedTravelTime: nil
      ),
      Task(
        id: UUID(),
        venueName: "City Center Grocery",
        address: "789 Mission Street, San Francisco, CA 94105",
        openingHours: "8:00 AM - 8:00 PM",
        plannedVisitTime: calendar.date(byAdding: .hour, value: 5, to: today) ?? now,
        status: .enRoute,
        visitingOrder: 3,
        photoURL: URL(string: "https://images.unsplash.com/photo-1556910096-6f5e72db6803?w=800&q=80")!,
        location: CLLocationCoordinate2D(latitude: 37.7949, longitude: -122.3994),
        distanceFromCurrentLocation: nil,
        estimatedTravelTime: nil
      ),
      Task(
        id: UUID(),
        venueName: "Bay Area Hardware Store",
        address: "321 Folsom Street, San Francisco, CA 94107",
        openingHours: "7:00 AM - 7:00 PM",
        plannedVisitTime: calendar.date(byAdding: .hour, value: 7, to: today) ?? now,
        status: .planned,
        visitingOrder: 4,
        photoURL: URL(string: "https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800&q=80")!,
        location: CLLocationCoordinate2D(latitude: 37.8049, longitude: -122.3894),
        distanceFromCurrentLocation: nil,
        estimatedTravelTime: nil
      ),
      Task(
        id: UUID(),
        venueName: "Pacific Bookstore",
        address: "654 California Street, San Francisco, CA 94108",
        openingHours: "10:00 AM - 6:00 PM",
        plannedVisitTime: calendar.date(byAdding: .hour, value: 9, to: today) ?? now,
        status: .done,
        visitingOrder: 5,
        photoURL: URL(string: "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800&q=80")!,
        location: CLLocationCoordinate2D(latitude: 37.8149, longitude: -122.3794),
        distanceFromCurrentLocation: nil,
        estimatedTravelTime: nil
      ),
      Task(
        id: UUID(),
        venueName: "Golden Gate Bakery",
        address: "987 Geary Street, San Francisco, CA 94109",
        openingHours: "6:00 AM - 4:00 PM",
        plannedVisitTime: calendar.date(byAdding: .hour, value: 11, to: today) ?? now,
        status: .planned,
        visitingOrder: 6,
        photoURL: URL(string: "https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=800&q=80")!,
        location: CLLocationCoordinate2D(latitude: 37.8249, longitude: -122.3694),
        distanceFromCurrentLocation: nil,
        estimatedTravelTime: nil
      ),
      Task(
        id: UUID(),
        venueName: "Union Square Electronics",
        address: "147 Powell Street, San Francisco, CA 94102",
        openingHours: "9:00 AM - 7:00 PM",
        plannedVisitTime: calendar.date(byAdding: .hour, value: 13, to: today) ?? now,
        status: .planned,
        visitingOrder: 7,
        photoURL: URL(string: "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=800&q=80")!,
        location: CLLocationCoordinate2D(latitude: 37.8349, longitude: -122.3594),
        distanceFromCurrentLocation: nil,
        estimatedTravelTime: nil
      ),
      Task(
        id: UUID(),
        venueName: "Mission District Florist",
        address: "258 Valencia Street, San Francisco, CA 94110",
        openingHours: "8:00 AM - 6:00 PM",
        plannedVisitTime: calendar.date(byAdding: .hour, value: 15, to: today) ?? now,
        status: .inProgress,
        visitingOrder: 8,
        photoURL: URL(string: "https://images.unsplash.com/photo-1563241527-3004b7be0ffd?w=800&q=80")!,
        location: CLLocationCoordinate2D(latitude: 37.8449, longitude: -122.3494),
        distanceFromCurrentLocation: nil,
        estimatedTravelTime: nil
      )
    ]
  }
}
