// (c) Copyright PopAppFactory 2024

import Foundation
import RIBs
import RxSwift
import RxRelay
import CoreLocation

/// sourcery: CreateMock
protocol LocationServiceWorking: Working {
  var currentLocation: Observable<CLLocation?> { get }
  var authorizationStatus: Observable<CLAuthorizationStatus> { get }
}

final class LocationServiceWorker: Worker, LocationServiceWorking {
  
  var currentLocation: Observable<CLLocation?> {
    return currentLocationSubject.asObservable()
  }
  
  var authorizationStatus: Observable<CLAuthorizationStatus> {
    return authorizationStatusSubject.asObservable()
  }
  
  private let locationManager = CLLocationManager()
  private lazy var locationDelegate: LocationDelegate = {
    LocationDelegate(
      onLocationUpdate: { [weak self] location in
        self?.currentLocationSubject.onNext(location)
      },
      onLocationError: { [weak self] in
        self?.currentLocationSubject.onNext(nil)
      },
      onAuthorizationChange: { [weak self] status in
        self?.authorizationStatusSubject.onNext(status)
      }
    )
  }()
  private let currentLocationSubject = BehaviorSubject<CLLocation?>(value: nil)
  private let authorizationStatusSubject = BehaviorSubject<CLAuthorizationStatus>(value: .notDetermined)
  
  override func didStart(_ interactorScope: any InteractorScope) {
    super.didStart(interactorScope)
    
    locationManager.delegate = locationDelegate
    locationManager.distanceFilter = 100 // meters
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    
    // Check current authorization status
    let status = locationManager.authorizationStatus
    authorizationStatusSubject.onNext(status)
    
    // Request permission if not determined
    if status == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
    } else if status == .authorizedWhenInUse || status == .authorizedAlways {
      locationManager.startUpdatingLocation()
    }
  }
}

// MARK: - LocationDelegate

private final class LocationDelegate: NSObject, CLLocationManagerDelegate {
  private let onLocationUpdate: (CLLocation) -> Void
  private let onLocationError: () -> Void
  private let onAuthorizationChange: (CLAuthorizationStatus) -> Void
  
  init(onLocationUpdate: @escaping (CLLocation) -> Void,
       onLocationError: @escaping () -> Void,
       onAuthorizationChange: @escaping (CLAuthorizationStatus) -> Void) {
    self.onLocationUpdate = onLocationUpdate
    self.onLocationError = onLocationError
    self.onAuthorizationChange = onAuthorizationChange
    super.init()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    onLocationUpdate(location)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    // On error, emit nil to indicate location unavailable
    onLocationError()
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    onAuthorizationChange(status)
    
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      manager.startUpdatingLocation()
    case .denied, .restricted:
      onLocationError() // Emit nil when permission denied
      manager.stopUpdatingLocation()
    case .notDetermined:
      break
    @unknown default:
      break
    }
  }
}
