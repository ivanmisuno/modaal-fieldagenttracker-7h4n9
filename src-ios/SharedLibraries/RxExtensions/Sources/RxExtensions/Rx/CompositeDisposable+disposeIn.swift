// (c) Copyright PopAppFactory 2023

import RxSwift

extension Disposable {
  @inlinable
  @discardableResult
  public func insert(into compositeDisposable: CompositeDisposable) -> CompositeDisposable.DisposeKey? {
    return compositeDisposable.insert(self)
  }
}
