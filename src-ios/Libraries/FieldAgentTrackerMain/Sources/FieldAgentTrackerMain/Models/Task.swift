// (c) Copyright PopAppFactory 2024

import Foundation
import CoreLocation

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
  
  static func == (lhs: Task, rhs: Task) -> Bool {
    return lhs.id == rhs.id &&
           lhs.venueName == rhs.venueName &&
           lhs.address == rhs.address &&
           lhs.openingHours == rhs.openingHours &&
           lhs.plannedVisitTime == rhs.plannedVisitTime &&
           lhs.status == rhs.status &&
           lhs.visitingOrder == rhs.visitingOrder &&
           lhs.photoURL == rhs.photoURL &&
           lhs.location.latitude == rhs.location.latitude &&
           lhs.location.longitude == rhs.location.longitude &&
           lhs.distanceFromCurrentLocation == rhs.distanceFromCurrentLocation &&
           lhs.estimatedTravelTime == rhs.estimatedTravelTime
  }
}
