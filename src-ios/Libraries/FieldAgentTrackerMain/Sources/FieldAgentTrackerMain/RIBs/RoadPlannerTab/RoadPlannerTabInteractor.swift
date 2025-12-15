// (c) Copyright PopAppFactory 2024

import UIKit
import RIBs

/// sourcery: CreateMock
protocol RoadPlannerTabRouting: ViewableRouting {
}

/// sourcery: CreateMock
protocol RoadPlannerTabListener: AnyObject {
}

/// sourcery: CreateMock
protocol RoadPlannerTabPresentable: Presentable {
}

final class RoadPlannerTabInteractor: PresentableInteractor<RoadPlannerTabPresentable>, RoadPlannerTabInteractable {

  weak var router: RoadPlannerTabRouting?
  weak var listener: RoadPlannerTabListener?

  override init(presenter: RoadPlannerTabPresentable) {
    super.init(presenter: presenter)
  }

  override func didBecomeActive() {
    super.didBecomeActive()
  }

  override func willResignActive() {
    super.willResignActive()
  }
}
