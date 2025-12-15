// (c) Copyright PopAppFactory 2023

import RxSwift

/// sourcery: CreateMock
public protocol Storing {

  // MARK: - Generic document store
  func document(_ path: String) -> DocumentStoring
  func collection(_ path: String) -> CollectionStoring
}
