// (c) Copyright PopAppFactory 2024

import UIKit
import RIBs

/// sourcery: CreateMock
protocol SettingsTabRouting: ViewableRouting {
}

/// sourcery: CreateMock
protocol SettingsTabListener: AnyObject {
}

/// sourcery: CreateMock
protocol SettingsTabPresentable: Presentable {
}

final class SettingsTabInteractor: PresentableInteractor<SettingsTabPresentable>, SettingsTabInteractable {

  weak var router: SettingsTabRouting?
  weak var listener: SettingsTabListener?

  override init(presenter: SettingsTabPresentable) {
    super.init(presenter: presenter)
  }

  override func didBecomeActive() {
    super.didBecomeActive()
  }

  override func willResignActive() {
    super.willResignActive()
  }
}
