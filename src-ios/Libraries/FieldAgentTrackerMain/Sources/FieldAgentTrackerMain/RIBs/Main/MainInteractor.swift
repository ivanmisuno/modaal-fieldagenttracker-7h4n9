// (c) Copyright PopAppFactory 2024

import UIKit
import RIBs
import RxSwift
import RxRelay
import RxCocoa

/// sourcery: CreateMock
protocol MainRouting: ViewableRouting {
}

/// sourcery: CreateMock
protocol MainListener: AnyObject, HomeTabListener, CalendarTabListener, RoadPlannerTabListener, SettingsTabListener {
}

final class MainInteractor: Interactor, MainInteractable {

  weak var router: MainRouting?
  weak var listener: MainListener?

  override init() {
    super.init()
  }

  override func didBecomeActive() {
    super.didBecomeActive()
  }

  override func willResignActive() {
    super.willResignActive()
  }
}
