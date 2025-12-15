// (c) Copyright PopAppFactory 2023 

import Foundation

/// sourcery: CreateMock
public protocol FirebaseAnalyticsProtocol {
  func logEvent(name: String, parameters: [String: Any]?)
  func setUserProperty(_ value: String?, forName name: String)
  func setUserID(_ userID: String?)
}
