//(c) Copyright PopAppFactory 2023

import RxSwift

/// sourcery: CreateMock
public protocol CloudStorageListResultProtocol {
  func prefixes() -> [CloudStorageReferencing]
  func items() -> [CloudStorageReferencing]
}

/// sourcery: CreateMock
public protocol CloudCollectionStoring {
  func listAll() -> Single<CloudStorageListResultProtocol>
}
