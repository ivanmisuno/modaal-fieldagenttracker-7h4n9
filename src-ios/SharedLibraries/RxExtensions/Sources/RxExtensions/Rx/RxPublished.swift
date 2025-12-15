// (c) Copyright PopAppFactory 2025

import Foundation
import RxSwift
import RxRelay

@propertyWrapper
public class RxPublished<Value> {
  private let relay: BehaviorRelay<Value>

  public var wrappedValue: Value {
    get { relay.value }
    set { relay.accept(newValue) }
  }

  public var projectedValue: BehaviorRelay<Value> {
    return relay
  }

  public init(wrappedValue: Value) {
    self.relay = BehaviorRelay(value: wrappedValue)
  }
}
