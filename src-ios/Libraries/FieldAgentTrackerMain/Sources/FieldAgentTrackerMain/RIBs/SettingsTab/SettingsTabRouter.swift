// (c) Copyright PopAppFactory 2024

import RIBs
import UIKit
import SharedUtility

/// sourcery: CreateMock
protocol SettingsTabInteractable: Interactable {
  var router: SettingsTabRouting? { get set }
  var listener: SettingsTabListener? { get set }
}

/// sourcery: CreateMock
protocol SettingsTabViewControllable: ViewControllable {
}

final class SettingsTabRouter: ViewableRouter<SettingsTabInteractable, SettingsTabViewControllable>, SettingsTabRouting {

  let navigationController: NavigationControllable

  init(navigationController: NavigationControllable,
       interactor: SettingsTabInteractable,
       viewController: SettingsTabViewControllable) {

    self.navigationController = navigationController

    super.init(interactor: interactor, viewController: viewController)

    interactor.router = self
  }

  // MARK: - Router overrides

  override func didLoad() {
    super.didLoad()
  }
}
