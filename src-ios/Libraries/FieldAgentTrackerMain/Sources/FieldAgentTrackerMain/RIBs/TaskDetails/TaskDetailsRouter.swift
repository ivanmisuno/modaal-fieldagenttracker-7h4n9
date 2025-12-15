// (c) Copyright PopAppFactory 2024

import RIBs
import UIKit

/// sourcery: CreateMock
protocol TaskDetailsInteractable: Interactable {
  var router: TaskDetailsRouting? { get set }
  var listener: TaskDetailsListener? { get set }
}

/// sourcery: CreateMock
protocol TaskDetailsViewControllable: ViewControllable {
}

final class TaskDetailsRouter: ViewableRouter<TaskDetailsInteractable, TaskDetailsViewControllable>, TaskDetailsRouting {

  override init(interactor: TaskDetailsInteractable,
       viewController: TaskDetailsViewControllable) {

    super.init(interactor: interactor, viewController: viewController)

    interactor.router = self
  }

  // MARK: - Router overrides

  override func didLoad() {
    super.didLoad()
  }
}
