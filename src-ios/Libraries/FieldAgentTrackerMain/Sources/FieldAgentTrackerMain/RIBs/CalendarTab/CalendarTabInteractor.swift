// (c) Copyright PopAppFactory 2024

import UIKit
import RIBs

/// sourcery: CreateMock
protocol CalendarTabRouting: ViewableRouting {
}

/// sourcery: CreateMock
protocol CalendarTabListener: AnyObject {
}

/// sourcery: CreateMock
protocol CalendarTabPresentable: Presentable {
}

final class CalendarTabInteractor: PresentableInteractor<CalendarTabPresentable>, CalendarTabInteractable {

  weak var router: CalendarTabRouting?
  weak var listener: CalendarTabListener?

  override init(presenter: CalendarTabPresentable) {
    super.init(presenter: presenter)
  }

  override func didBecomeActive() {
    super.didBecomeActive()
  }

  override func willResignActive() {
    super.willResignActive()
  }
}
