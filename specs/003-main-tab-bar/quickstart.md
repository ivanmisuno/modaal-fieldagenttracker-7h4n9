# Quickstart: Main Tab Bar Navigation

**Feature**: 003-main-tab-bar
**Date**: 2025-12-15

## Overview

This guide provides a step-by-step implementation sequence for converting Main RIB to a tab bar coordinator and creating the four tab RIBs.

## Implementation Sequence

### Step 1: Create Placeholder Tab RIBs

Create the three placeholder tab RIBs first to establish the structure:

1. **CalendarTab RIB**:
   - Create `RIBs/CalendarTab/` directory
   - Scaffold Builder, Interactor, Router, ViewController files
   - Implement placeholder SwiftUI view with "Calendar" text and icon
   - Mark all protocols with `/// sourcery: CreateMock`

2. **RoadPlannerTab RIB**:
   - Create `RIBs/RoadPlannerTab/` directory
   - Scaffold Builder, Interactor, Router, ViewController files
   - Implement placeholder SwiftUI view with "Road Planner" text and icon
   - Mark all protocols with `/// sourcery: CreateMock`

3. **SettingsTab RIB**:
   - Create `RIBs/SettingsTab/` directory
   - Scaffold Builder, Interactor, Router, ViewController files
   - Implement placeholder SwiftUI view with "Settings" text and icon
   - Mark all protocols with `/// sourcery: CreateMock`

**Validation**: Build succeeds, placeholder RIBs compile

### Step 2: Create HomeTab RIB

Extract task list functionality from Main RIB:

1. **Create HomeTab RIB structure**:
   - Create `RIBs/HomeTab/` directory
   - Scaffold Builder, Interactor, Router, ViewController files

2. **Move task list code**:
   - Move `MainView.swift` content to `HomeTabView.swift`
   - Move `MainViewState` to `HomeTabViewState`
   - Move `MainViewController` logic to `HomeTabViewController`
   - Update references (MainView → HomeTabView, etc.)

3. **Update HomeTab dependencies**:
   - HomeTabDependency: themeProvider, dailyPlannerWorker, taskDetailsBuilder
   - HomeTabInteractor: subscribes to dailyPlannerWorker.tasks
   - HomeTabPresentable: tasks: Binder<[Task]>, taskTapped: Observable<Task>
   - HomeTabRouting: routeToTaskDetails(task:), routeFromTaskDetails()

4. **Wire TaskDetails integration**:
   - HomeTabRouter receives taskDetailsBuilder
   - Implement routeToTaskDetails with modal presentation
   - Implement routeFromTaskDetails with dismiss

**Validation**: Build succeeds, HomeTab displays task list correctly

### Step 3: Refactor Main RIB to View-less Coordinator

Convert Main RIB from view-having to view-less:

1. **Update MainDependency**:
   - Add homeTabBuilder, calendarTabBuilder, roadPlannerTabBuilder, settingsTabBuilder
   - Remove dailyPlannerWorker, taskDetailsBuilder (moved to HomeTab)

2. **Update MainBuilder**:
   - Remove MainViewController creation
   - Remove MainPresentable usage
   - Create UITabBarController
   - Build all four tab RIBs
   - Wrap each tab in UINavigationController
   - Set tab bar view controllers

3. **Update MainInteractor**:
   - Convert from PresentableInteractor to base Interactor
   - Remove presenter dependency
   - Remove task-related subscriptions (moved to HomeTab)
   - No Presentable protocol needed

4. **Update MainRouter**:
   - Store UITabBarController
   - Remove taskDetailsBuilder (moved to HomeTab)
   - Remove routeToTaskDetails/routeFromTaskDetails (moved to HomeTab)
   - ViewControllable is UITabBarController
   - Attach all four tab RIBs on initialization

5. **Update MainComponent**:
   - Provide tab builders to MainDependency
   - Remove dailyPlannerWorker, taskDetailsBuilder (moved to HomeTab)

**Validation**: Build succeeds, Main RIB compiles as view-less

### Step 4: Update Root Integration

Update RootRouter to work with view-less Main RIB:

1. **Update RootComponent**:
   - Add homeTabBuilder, calendarTabBuilder, roadPlannerTabBuilder, settingsTabBuilder
   - Provide tab builders to MainDependency

2. **Update RootRouter.routeToMain()**:
   - Remove NavigationController creation (Main no longer needs it)
   - Embed MainRouter's UITabBarController directly
   - Update view hierarchy embedding

**Validation**: Build succeeds, app launches with tab bar

### Step 5: Configure Tab Bar Appearance

Set up tab bar icons and labels:

1. **Configure UITabBarController**:
   - Set tab bar items with SF Symbols
   - Set tab titles: "Main", "Calendar", "Road Planner", "Settings"
   - Configure tab bar appearance (colors, styling)

2. **Test tab switching**:
   - Verify all tabs are accessible
   - Verify tab state preservation
   - Verify navigation stacks per tab

**Validation**: Tab bar displays correctly, all tabs functional

### Step 6: Verify Integration

1. **Test HomeTab**:
   - Task list displays correctly
   - Task taps open TaskDetails modal
   - TaskDetails can be dismissed
   - Real-time distance updates work

2. **Test Placeholder Tabs**:
   - Calendar tab displays placeholder
   - Road Planner tab displays placeholder
   - Settings tab displays placeholder

3. **Test Tab Switching**:
   - Switch between tabs
   - Verify state preservation
   - Verify navigation stacks maintained

**Validation**: All functionality works as expected

## Code Patterns

### MainRouter Tab Bar Setup

```swift
final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
    let tabBarController: UITabBarController
    
    init(interactor: MainInteractable,
         homeTabBuilder: HomeTabBuildable,
         calendarTabBuilder: CalendarTabBuildable,
         roadPlannerTabBuilder: RoadPlannerTabBuildable,
         settingsTabBuilder: SettingsTabBuildable) {
        
        // Create UITabBarController
        let tabBarController = UITabBarController()
        self.tabBarController = tabBarController
        
        // Build tab RIBs
        let homeTabRouter = homeTabBuilder.build(
            withListener: interactor,
            navigationController: UINavigationController())
        // ... build other tabs
        
        // Wrap in navigation controllers
        let homeNC = UINavigationController(
            rootViewController: homeTabRouter.viewControllable.uiviewController)
        // ... create other navigation controllers
        
        // Set tab bar items
        homeNC.tabBarItem = UITabBarItem(
            title: "Main",
            image: UIImage(systemName: "house.fill"),
            tag: 0)
        // ... configure other tab items
        
        // Set view controllers
        tabBarController.viewControllers = [homeNC, calendarNC, roadPlannerNC, settingsNC]
        
        // Attach child RIBs
        attachChild(homeTabRouter)
        // ... attach other tabs
        
        super.init(interactor: interactor, viewController: tabBarController)
    }
}
```

### HomeTab Interactor Pattern

```swift
final class HomeTabInteractor: PresentableInteractor<HomeTabPresentable>, HomeTabInteractable {
    private let dailyPlannerWorker: DailyPlannerWorking
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        dailyPlannerWorker.start(self)
        
        dailyPlannerWorker.tasks
            .observe(on: MainScheduler.instance)
            .bind(to: presenter.tasks)
            .disposeOnDeactivate(interactor: self)
        
        presenter.taskTapped
            .subscribe(onNext: { [router] task in
                router?.routeToTaskDetails(task: task)
            })
            .disposeOnDeactivate(interactor: self)
    }
}
```

## Common Pitfalls

1. **Forgetting to attach child RIBs**: Always call `attachChild()` for each tab RIB
2. **NavigationController discovery**: Don't discover nav controllers - create and pass via DI
3. **State management**: Don't manually manage tab state - UIKit handles it
4. **Protocol placement**: Follow RIBs protocol organization rules strictly
5. **Dependency injection**: Extract concrete services in Builder, don't pass `*Dependency` to Interactors

## Validation Checklist

- [ ] All four tabs visible in tab bar
- [ ] Tab switching works correctly
- [ ] HomeTab displays task list
- [ ] TaskDetails opens from HomeTab
- [ ] Placeholder tabs display correctly
- [ ] Tab state preserved when switching
- [ ] Navigation stacks independent per tab
- [ ] Build succeeds without errors
- [ ] All protocols marked with `/// sourcery: CreateMock`
