// (c) Copyright PopAppFactory 2024

import RIBs
import UIKit
import SharedUtility

/// sourcery: CreateMock
protocol HomeTabInteractable: Interactable {
  var router: HomeTabRouting? { get set }
  var listener: HomeTabListener? { get set }
}

/// sourcery: CreateMock
protocol HomeTabViewControllable: ViewControllable {
}

final class HomeTabRouter: ViewableRouter<HomeTabInteractable, HomeTabViewControllable>, HomeTabRouting {

  let navigationController: NavigationControllable
  private let taskDetailsBuilder: TaskDetailsBuildable

  init(navigationController: NavigationControllable,
       interactor: HomeTabInteractable,
       viewController: HomeTabViewControllable,
       taskDetailsBuilder: TaskDetailsBuildable) {

    self.navigationController = navigationController
    self.taskDetailsBuilder = taskDetailsBuilder

    super.init(interactor: interactor, viewController: viewController)

    interactor.router = self
  }

  // MARK: - Router overrides

  override func didLoad() {
    super.didLoad()
  }
  
  // MARK: - HomeTabRouting
  
  func routeToTaskDetails(task: Task) {
    // Dismiss existing if any
    if children.contains(where: { $0 is TaskDetailsRouting }) {
      routeFromTaskDetails()
    }
    
    guard let taskDetailsListener = interactor as? TaskDetailsListener else {
      return
    }
    
    let taskDetailsRouter = taskDetailsBuilder.build(withListener: taskDetailsListener, task: task)
    let taskDetailsViewController = taskDetailsRouter.viewControllable.uiviewController
    
    taskDetailsViewController.modalPresentationStyle = .fullScreen
    
    viewController.uiviewController.present(taskDetailsViewController, animated: true)
    attachChild(taskDetailsRouter)
  }
  
  func routeFromTaskDetails() {
    guard let taskDetailsRouter = children.first(where: { $0 is TaskDetailsRouting }) as? TaskDetailsRouting else {
      return
    }
    let taskDetailsViewController = taskDetailsRouter.viewControllable.uiviewController
    detachChild(taskDetailsRouter)
    taskDetailsViewController.dismiss(animated: true)
  }
}
