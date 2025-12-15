// (c) Copyright PopAppFactory 2023 

import Foundation

public protocol OptionalType {
  associatedtype Wrapped
  func flatMap<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U?
}

extension Optional: OptionalType {
}
