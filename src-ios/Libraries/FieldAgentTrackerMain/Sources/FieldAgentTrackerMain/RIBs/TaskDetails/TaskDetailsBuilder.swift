// (c) Copyright PopAppFactory 2024

import UIKit
import RIBs
import SimpleTheming

/// sourcery: CreateMock
protocol TaskDetailsDependency: Dependency {
  var themeProvider: ThemeProviding { get }
}

final class TaskDetailsComponent: Component<TaskDetailsDependency> {
  var themeProvider: ThemeProviding { dependency.themeProvider }
}

// MARK: - Builder

/// sourcery: CreateMock
protocol TaskDetailsBuildable: Buildable {
  func build(withListener listener: TaskDetailsListener, task: Task) -> TaskDetailsRouting
}

final class TaskDetailsBuilder: Builder<TaskDetailsDependency>, TaskDetailsBuildable {

  override init(dependency: TaskDetailsDependency) {
    super.init(dependency: dependency)
  }

  func build(withListener listener: TaskDetailsListener, task: Task) -> TaskDetailsRouting {
    let component = TaskDetailsComponent(dependency: dependency)

    let viewController = TaskDetailsViewController(
      themeProvider: component.themeProvider)

    let interactor = TaskDetailsInteractor(
      task: task,
      presenter: viewController)

    interactor.listener = listener

    let router = TaskDetailsRouter(
      interactor: interactor,
      viewController: viewController)

    return router
  }
}
