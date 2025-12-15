// (c) Copyright PopAppFactory 2024

import RIBs
import UIKit
import SharedUtility

/// sourcery: CreateMock
protocol RoadPlannerTabInteractable: Interactable {
  var router: RoadPlannerTabRouting? { get set }
  var listener: RoadPlannerTabListener? { get set }
}

/// sourcery: CreateMock
protocol RoadPlannerTabViewControllable: ViewControllable {
}

final class RoadPlannerTabRouter: ViewableRouter<RoadPlannerTabInteractable, RoadPlannerTabViewControllable>, RoadPlannerTabRouting {

  let navigationController: NavigationControllable

  init(navigationController: NavigationControllable,
       interactor: RoadPlannerTabInteractable,
       viewController: RoadPlannerTabViewControllable) {

    self.navigationController = navigationController

    super.init(interactor: interactor, viewController: viewController)

    interactor.router = self
  }

  // MARK: - Router overrides

  override func didLoad() {
    super.didLoad()
  }
}
