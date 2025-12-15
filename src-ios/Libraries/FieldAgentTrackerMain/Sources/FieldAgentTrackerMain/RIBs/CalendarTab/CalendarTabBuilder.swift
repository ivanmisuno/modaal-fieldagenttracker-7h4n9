// (c) Copyright PopAppFactory 2024

import UIKit
import RIBs
import SimpleTheming
import SharedUtility

/// sourcery: CreateMock
protocol CalendarTabDependency: Dependency {
  var themeProvider: ThemeProviding { get }
}

final class CalendarTabComponent: Component<CalendarTabDependency> {
  var themeProvider: ThemeProviding { dependency.themeProvider }
}

// MARK: - Builder

/// sourcery: CreateMock
protocol CalendarTabBuildable: Buildable {
  func build(withListener listener: CalendarTabListener, navigationController: NavigationControllable) -> CalendarTabRouting
}

final class CalendarTabBuilder: Builder<CalendarTabDependency>, CalendarTabBuildable {

  override init(dependency: CalendarTabDependency) {
    super.init(dependency: dependency)
  }

  func build(withListener listener: CalendarTabListener, navigationController: NavigationControllable) -> CalendarTabRouting {
    let component = CalendarTabComponent(dependency: dependency)

    let viewController = CalendarTabViewController(
      themeProvider: component.themeProvider)

    let interactor = CalendarTabInteractor(
      presenter: viewController)

    interactor.listener = listener

    let router = CalendarTabRouter(
      navigationController: navigationController,
      interactor: interactor,
      viewController: viewController)

    return router
  }
}
