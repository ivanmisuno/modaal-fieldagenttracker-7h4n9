// (c) Copyright PopAppFactory 2024

import UIKit
import RIBs
import SimpleTheming
import SharedUtility

/// sourcery: CreateMock
protocol SettingsTabDependency: Dependency {
  var themeProvider: ThemeProviding { get }
}

final class SettingsTabComponent: Component<SettingsTabDependency> {
  var themeProvider: ThemeProviding { dependency.themeProvider }
}

// MARK: - Builder

/// sourcery: CreateMock
protocol SettingsTabBuildable: Buildable {
  func build(withListener listener: SettingsTabListener, navigationController: NavigationControllable) -> SettingsTabRouting
}

final class SettingsTabBuilder: Builder<SettingsTabDependency>, SettingsTabBuildable {

  override init(dependency: SettingsTabDependency) {
    super.init(dependency: dependency)
  }

  func build(withListener listener: SettingsTabListener, navigationController: NavigationControllable) -> SettingsTabRouting {
    let component = SettingsTabComponent(dependency: dependency)

    let viewController = SettingsTabViewController(
      themeProvider: component.themeProvider)

    let interactor = SettingsTabInteractor(
      presenter: viewController)

    interactor.listener = listener

    let router = SettingsTabRouter(
      navigationController: navigationController,
      interactor: interactor,
      viewController: viewController)

    return router
  }
}
