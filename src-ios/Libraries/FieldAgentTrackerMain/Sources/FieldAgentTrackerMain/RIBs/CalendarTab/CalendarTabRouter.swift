// (c) Copyright PopAppFactory 2024

import RIBs
import UIKit
import SharedUtility

/// sourcery: CreateMock
protocol CalendarTabInteractable: Interactable {
  var router: CalendarTabRouting? { get set }
  var listener: CalendarTabListener? { get set }
}

/// sourcery: CreateMock
protocol CalendarTabViewControllable: ViewControllable {
}

final class CalendarTabRouter: ViewableRouter<CalendarTabInteractable, CalendarTabViewControllable>, CalendarTabRouting {

  let navigationController: NavigationControllable

  init(navigationController: NavigationControllable,
       interactor: CalendarTabInteractable,
       viewController: CalendarTabViewControllable) {

    self.navigationController = navigationController

    super.init(interactor: interactor, viewController: viewController)

    interactor.router = self
  }

  // MARK: - Router overrides

  override func didLoad() {
    super.didLoad()
  }
}
