// (c) Copyright PopAppFactory 2024

import UIKit
import RIBs
import SharedUtility
import SimpleTheming
import Storage

/// sourcery: CreateMock
protocol MainDependency: Dependency {
  var themeProvider: ThemeProviding { get }
  var homeTabBuilder: HomeTabBuildable { get }
  var calendarTabBuilder: CalendarTabBuildable { get }
  var roadPlannerTabBuilder: RoadPlannerTabBuildable { get }
  var settingsTabBuilder: SettingsTabBuildable { get }
}

final class MainComponent: Component<MainDependency> {
  var themeProvider: ThemeProviding { dependency.themeProvider }
  var homeTabBuilder: HomeTabBuildable { dependency.homeTabBuilder }
  var calendarTabBuilder: CalendarTabBuildable { dependency.calendarTabBuilder }
  var roadPlannerTabBuilder: RoadPlannerTabBuildable { dependency.roadPlannerTabBuilder }
  var settingsTabBuilder: SettingsTabBuildable { dependency.settingsTabBuilder }
}

// MARK: - Builder

/// sourcery: CreateMock
protocol MainBuildable: Buildable {
  func build(withListener listener: MainListener) -> MainRouting
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {

  override init(dependency: MainDependency) {
    super.init(dependency: dependency)
  }

  func build(withListener listener: MainListener) -> MainRouting {
    let component = MainComponent(dependency: dependency)

    // Create UITabBarController
    let tabBarController = UITabBarController()
    
    // Build tabs
    let (homeTabRouter, homeNav) = buildHomeTab(
      builder: component.homeTabBuilder,
      listener: listener)
    let (calendarTabRouter, calendarNav) = buildCalendarTab(
      builder: component.calendarTabBuilder,
      listener: listener)
    let (roadPlannerTabRouter, roadPlannerNav) = buildRoadPlannerTab(
      builder: component.roadPlannerTabBuilder,
      listener: listener)
    let (settingsTabRouter, settingsNav) = buildSettingsTab(
      builder: component.settingsTabBuilder,
      listener: listener)
    
    // Configure tab bar
    configureTabBar(
      tabBarController: tabBarController,
      viewControllers: [homeNav, calendarNav, roadPlannerNav, settingsNav])

    let interactor = MainInteractor()
    interactor.listener = listener

    let router = MainRouter(
      interactor: interactor,
      tabBarController: tabBarController,
      homeTabRouter: homeTabRouter,
      calendarTabRouter: calendarTabRouter,
      roadPlannerTabRouter: roadPlannerTabRouter,
      settingsTabRouter: settingsTabRouter)

    return router
  }
  
  private func buildHomeTab(
    builder: HomeTabBuildable,
    listener: MainListener
  ) -> (HomeTabRouting, UINavigationController) {
    let nav = UINavigationController()
    let router: HomeTabRouting = builder.build(
      withListener: listener,
      navigationController: nav)
    nav.setViewControllers([router.viewControllable.uiviewController], animated: false)
    nav.tabBarItem = UITabBarItem(
      title: "Main",
      image: UIImage(systemName: "house.fill"),
      tag: 0)
    return (router, nav)
  }
  
  private func buildCalendarTab(
    builder: CalendarTabBuildable,
    listener: MainListener
  ) -> (CalendarTabRouting, UINavigationController) {
    let nav = UINavigationController()
    let router: CalendarTabRouting = builder.build(
      withListener: listener,
      navigationController: nav)
    nav.setViewControllers([router.viewControllable.uiviewController], animated: false)
    nav.tabBarItem = UITabBarItem(
      title: "Calendar",
      image: UIImage(systemName: "calendar"),
      tag: 1)
    return (router, nav)
  }
  
  private func buildRoadPlannerTab(
    builder: RoadPlannerTabBuildable,
    listener: MainListener
  ) -> (RoadPlannerTabRouting, UINavigationController) {
    let nav = UINavigationController()
    let router: RoadPlannerTabRouting = builder.build(
      withListener: listener,
      navigationController: nav)
    nav.setViewControllers([router.viewControllable.uiviewController], animated: false)
    nav.tabBarItem = UITabBarItem(
      title: "Road Planner",
      image: UIImage(systemName: "map"),
      tag: 2)
    return (router, nav)
  }
  
  private func buildSettingsTab(
    builder: SettingsTabBuildable,
    listener: MainListener
  ) -> (SettingsTabRouting, UINavigationController) {
    let nav = UINavigationController()
    let router: SettingsTabRouting = builder.build(
      withListener: listener,
      navigationController: nav)
    nav.setViewControllers([router.viewControllable.uiviewController], animated: false)
    nav.tabBarItem = UITabBarItem(
      title: "Settings",
      image: UIImage(systemName: "gearshape"),
      tag: 3)
    return (router, nav)
  }
  
  private func configureTabBar(
    tabBarController: UITabBarController,
    viewControllers: [UIViewController]
  ) {
    tabBarController.setViewControllers(viewControllers, animated: false)
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    tabBarController.tabBar.standardAppearance = appearance
    if #available(iOS 15.0, *) {
      tabBarController.tabBar.scrollEdgeAppearance = appearance
    }
  }
}
