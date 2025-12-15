// (c) Copyright PopAppFactory 2024

import RIBs
import UIKit
import SharedUtility

/// sourcery: CreateMock
protocol MainInteractable: Interactable {
  var router: MainRouting? { get set }
  var listener: MainListener? { get set }
}

/// sourcery: CreateMock
protocol MainViewControllable: ViewControllable {
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {

  private let tabBarController: UITabBarController
  private let homeTabRouter: HomeTabRouting
  private let calendarTabRouter: CalendarTabRouting
  private let roadPlannerTabRouter: RoadPlannerTabRouting
  private let settingsTabRouter: SettingsTabRouting

  init(interactor: MainInteractable,
       tabBarController: UITabBarController,
       homeTabRouter: HomeTabRouting,
       calendarTabRouter: CalendarTabRouting,
       roadPlannerTabRouter: RoadPlannerTabRouting,
       settingsTabRouter: SettingsTabRouting) {

    self.tabBarController = tabBarController
    self.homeTabRouter = homeTabRouter
    self.calendarTabRouter = calendarTabRouter
    self.roadPlannerTabRouter = roadPlannerTabRouter
    self.settingsTabRouter = settingsTabRouter

    // Create a ViewControllable wrapper for UITabBarController
    let viewControllable = MainTabBarController(tabBarController: tabBarController)

    super.init(interactor: interactor, viewController: viewControllable)

    interactor.router = self
  }

  // MARK: - Router overrides

  override func didLoad() {
    super.didLoad()
    
    // Attach all tab RIBs
    attachChild(homeTabRouter)
    attachChild(calendarTabRouter)
    attachChild(roadPlannerTabRouter)
    attachChild(settingsTabRouter)
  }
}

// MARK: - MainTabBarController

final class MainTabBarController: UIViewController, MainViewControllable {
  private let _tabBarController: UITabBarController
  
  init(tabBarController: UITabBarController) {
    self._tabBarController = tabBarController
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addChild(_tabBarController)
    view.addSubview(_tabBarController.view)
    _tabBarController.view.frame = view.bounds
    _tabBarController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    _tabBarController.didMove(toParent: self)
  }
  
  var uiviewController: UIViewController {
    return self
  }
}
