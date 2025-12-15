// (c) Copyright PopAppFactory 2023 

import Foundation

/// sourcery: CreateMock
public protocol FirebaseCrashlyticsProtocol: AnyObject {
  func setUserID(_ userID: String?)
  func setCustomValue(_ value: Any?, forKey key: String)

  func log(_ message: String)
  func record(error: Error, userInfo: [String: Any]?)
}
