// (c) Copyright PopAppFactory 2024

import UIKit
import RIBs
import SimpleTheming
import SharedUtility

/// sourcery: CreateMock
protocol RoadPlannerTabDependency: Dependency {
  var themeProvider: ThemeProviding { get }
}

final class RoadPlannerTabComponent: Component<RoadPlannerTabDependency> {
  var themeProvider: ThemeProviding { dependency.themeProvider }
}

// MARK: - Builder

/// sourcery: CreateMock
protocol RoadPlannerTabBuildable: Buildable {
  func build(withListener listener: RoadPlannerTabListener, navigationController: NavigationControllable) -> RoadPlannerTabRouting
}

final class RoadPlannerTabBuilder: Builder<RoadPlannerTabDependency>, RoadPlannerTabBuildable {

  override init(dependency: RoadPlannerTabDependency) {
    super.init(dependency: dependency)
  }

  func build(withListener listener: RoadPlannerTabListener, navigationController: NavigationControllable) -> RoadPlannerTabRouting {
    let component = RoadPlannerTabComponent(dependency: dependency)

    let viewController = RoadPlannerTabViewController(
      themeProvider: component.themeProvider)

    let interactor = RoadPlannerTabInteractor(
      presenter: viewController)

    interactor.listener = listener

    let router = RoadPlannerTabRouter(
      navigationController: navigationController,
      interactor: interactor,
      viewController: viewController)

    return router
  }
}
