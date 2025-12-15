// (c) Copyright PopAppFactory 2024

import UIKit
import RIBs
import SimpleTheming
import SharedUtility

/// sourcery: CreateMock
protocol HomeTabDependency: Dependency {
  var themeProvider: ThemeProviding { get }
  var dailyPlannerWorker: DailyPlannerWorking { get }
  var taskDetailsBuilder: TaskDetailsBuildable { get }
}

final class HomeTabComponent: Component<HomeTabDependency> {
  var themeProvider: ThemeProviding { dependency.themeProvider }
  var dailyPlannerWorker: DailyPlannerWorking { dependency.dailyPlannerWorker }
  var taskDetailsBuilder: TaskDetailsBuildable { dependency.taskDetailsBuilder }
}

// MARK: - Builder

/// sourcery: CreateMock
protocol HomeTabBuildable: Buildable {
  func build(withListener listener: HomeTabListener, navigationController: NavigationControllable) -> HomeTabRouting
}

final class HomeTabBuilder: Builder<HomeTabDependency>, HomeTabBuildable {

  override init(dependency: HomeTabDependency) {
    super.init(dependency: dependency)
  }

  func build(withListener listener: HomeTabListener, navigationController: NavigationControllable) -> HomeTabRouting {
    let component = HomeTabComponent(dependency: dependency)

    let viewController = HomeTabViewController(
      themeProvider: component.themeProvider)

    let interactor = HomeTabInteractor(
      dailyPlannerWorker: component.dailyPlannerWorker,
      presenter: viewController)

    interactor.listener = listener

    let router = HomeTabRouter(
      navigationController: navigationController,
      interactor: interactor,
      viewController: viewController,
      taskDetailsBuilder: component.taskDetailsBuilder)

    return router
  }
}
