# Quick Start Guide: Task Details Implementation

**Feature**: 002-task-details  
**Date**: 2025-01-27  
**Phase**: 1 (Design)

## Implementation Sequence

Follow this order to implement the feature incrementally, ensuring compilation at each step.

### Step 1: Create TaskDetails RIB Scaffolding

**Files**: `RIBs/TaskDetails/TaskDetailsBuilder.swift`, `TaskDetailsInteractor.swift`, `TaskDetailsRouter.swift`, `TaskDetailsView.swift`

1. Create `TaskDetails` directory
2. Create Builder with Dependency and Buildable protocols
3. Create Interactor with Presentable, Routing, Listener protocols
4. Create Router with Interactable, ViewControllable protocols
5. Create ViewController with SwiftUI View and ViewState

**Validation**: Compiles, RIB structure in place

---

### Step 2: Implement TaskDetailsBuilder

**File**: `RIBs/TaskDetails/TaskDetailsBuilder.swift`

1. Create `TaskDetailsDependency` protocol (requires themeProvider)
2. Create `TaskDetailsComponent` with themeProvider
3. Create `TaskDetailsBuildable` protocol with `build(withListener:task:)` method
4. Implement `TaskDetailsBuilder` that:
   - Creates TaskDetailsComponent
   - Creates TaskDetailsViewController
   - Creates TaskDetailsInteractor with Task parameter
   - Creates TaskDetailsRouter
   - Returns router

**Key Code Pattern**:
```swift
protocol TaskDetailsBuildable: Buildable {
    func build(withListener listener: TaskDetailsListener, task: Task) -> TaskDetailsRouting
}

final class TaskDetailsBuilder: Builder<TaskDetailsDependency>, TaskDetailsBuildable {
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
```

**Validation**: Compiles, Builder can be instantiated

---

### Step 3: Implement TaskDetailsInteractor

**File**: `RIBs/TaskDetails/TaskDetailsInteractor.swift`

1. Create `TaskDetailsPresentable` protocol with:
   - `var task: Binder<Task> { get }`
   - `var closeTapped: Observable<Void> { get }`
   - `var backTapped: Observable<Void> { get }`
2. Create `TaskDetailsRouting` protocol (empty, no child RIBs)
3. Create `TaskDetailsListener` protocol with `taskDetailsDidClose()`
4. Implement `TaskDetailsInteractor`:
   - Store Task parameter
   - In `didBecomeActive()`, bind Task to presenter.task
   - Subscribe to closeTapped and backTapped, notify listener

**Key Code Pattern**:
```swift
protocol TaskDetailsPresentable: Presentable {
    var task: Binder<Task> { get }
    var closeTapped: Observable<Void> { get }
    var backTapped: Observable<Void> { get }
}

final class TaskDetailsInteractor: PresentableInteractor<TaskDetailsPresentable>, TaskDetailsInteractable {
    private let task: Task
    weak var listener: TaskDetailsListener?
    
    init(task: Task, presenter: TaskDetailsPresentable) {
        self.task = task
        super.init(presenter: presenter)
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        presenter.task.onNext(task)
        
        presenter.closeTapped
            .merge(with: presenter.backTapped)
            .subscribe(onNext: { [listener] in
                listener?.taskDetailsDidClose()
            })
            .disposeOnDeactivate(interactor: self)
    }
}
```

**Validation**: Compiles, Interactor subscribes to events

---

### Step 4: Implement TaskDetailsRouter

**File**: `RIBs/TaskDetails/TaskDetailsRouter.swift`

1. Create `TaskDetailsInteractable` protocol
2. Create `TaskDetailsViewControllable` protocol
3. Implement `TaskDetailsRouter` (no special navigation logic needed)

**Key Code Pattern**:
```swift
protocol TaskDetailsInteractable: Interactable {
    var router: TaskDetailsRouting? { get set }
    var listener: TaskDetailsListener? { get set }
}

protocol TaskDetailsViewControllable: ViewControllable {
}

final class TaskDetailsRouter: ViewableRouter<TaskDetailsInteractable, TaskDetailsViewControllable>, TaskDetailsRouting {
    init(interactor: TaskDetailsInteractable, viewController: TaskDetailsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
```

**Validation**: Compiles, Router can be instantiated

---

### Step 5: Implement TaskDetailsViewController and View

**File**: `RIBs/TaskDetails/TaskDetailsView.swift`

1. Create `TaskDetailsViewState` with `@Published var task: Task?`
2. Create `TaskDetailsView` SwiftUI view displaying all task information
3. Create `TaskDetailsViewController` implementing Presentable:
   - Implement `task` Binder
   - Implement `closeTapped` Observable (from close button)
   - Implement `backTapped` Observable (from viewDidDisappear)
   - Handle swipe down dismissal detection

**Key Code Pattern**:
```swift
final class TaskDetailsViewController: UIHostingController<TaskDetailsView>, TaskDetailsPresentable, TaskDetailsViewControllable {
    private let viewState = TaskDetailsViewState()
    private let closeSubject = PublishSubject<Void>()
    private let backSubject = PublishSubject<Void>()
    
    var task: Binder<Task> {
        Binder(viewState) { state, task in
            state.task = task
        }
    }
    
    var closeTapped: Observable<Void> { closeSubject.asObservable() }
    var backTapped: Observable<Void> { backSubject.asObservable() }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            backSubject.onNext(())
        }
    }
}
```

**Validation**: Compiles, View displays task information

---

### Step 6: Wire TaskDetailsBuilder to MainDependency

**File**: `RIBs/Main/MainBuilder.swift` (update MainDependency)

1. Add `taskDetailsBuilder: TaskDetailsBuildable` to `MainDependency` protocol
2. Extend `RootComponent` to provide TaskDetailsBuilder
3. Add TaskDetailsBuilder to `MainComponent`

**Key Code Pattern**:
```swift
protocol MainDependency: Dependency {
    var themeProvider: ThemeProviding { get }
    var dailyPlannerWorker: DailyPlannerWorking { get }
    var taskDetailsBuilder: TaskDetailsBuildable { get } // NEW
}

extension RootComponent: MainDependency {
    var taskDetailsBuilder: TaskDetailsBuildable {
        TaskDetailsBuilder(dependency: self)
    }
}
```

**Validation**: Compiles, MainDependency includes TaskDetailsBuilder

---

### Step 7: Update MainRouter

**File**: `RIBs/Main/MainRouter.swift`

1. Add `taskDetailsBuilder: TaskDetailsBuildable` property
2. Implement `routeToTaskDetails(task:)` method:
   - Build TaskDetails RIB
   - Configure modal presentation style
   - Present modally
   - Attach child
3. Implement `routeFromTaskDetails()` method:
   - Find TaskDetails router in children
   - Dismiss view controller
   - Detach child

**Key Code Pattern**:
```swift
final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
    private let taskDetailsBuilder: TaskDetailsBuildable
    
    func routeToTaskDetails(task: Task) {
        // Dismiss existing if any
        if let existing = children.first(where: { $0 is TaskDetailsRouting }) {
            routeFromTaskDetails()
        }
        
        let taskDetailsRouter = taskDetailsBuilder.build(withListener: interactor, task: task)
        let viewController = taskDetailsRouter.viewControllable.uiviewController
        
        viewController.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if let sheet = viewController.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
        }
        
        self.viewController.present(viewController, animated: true)
        attachChild(taskDetailsRouter)
    }
    
    func routeFromTaskDetails() {
        guard let taskDetailsRouter = children.first(where: { $0 is TaskDetailsRouting }) as? TaskDetailsRouting else {
            return
        }
        detachChild(taskDetailsRouter)
        taskDetailsRouter.viewControllable.uiviewController.dismiss(animated: true)
    }
}
```

**Validation**: Compiles, Router can present/dismiss TaskDetails

---

### Step 8: Update MainInteractor

**File**: `RIBs/Main/MainInteractor.swift`

1. Add `taskTapped: Observable<Task>` to `MainPresentable` protocol
2. In `MainInteractor.didBecomeActive()`, subscribe to `presenter.taskTapped`
3. Request routing to TaskDetails when task tapped
4. Implement `TaskDetailsListener` protocol:
   - `func taskDetailsDidClose()` calls `router?.routeFromTaskDetails()`

**Key Code Pattern**:
```swift
protocol MainPresentable: Presentable {
    var tasks: Binder<[Task]> { get }
    var taskTapped: Observable<Task> { get } // NEW
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, TaskDetailsListener {
    override func didBecomeActive() {
        // ... existing code
        
        presenter.taskTapped
            .subscribe(onNext: { [router] task in
                router?.routeToTaskDetails(task: task)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    // MARK: - TaskDetailsListener
    func taskDetailsDidClose() {
        router?.routeFromTaskDetails()
    }
}
```

**Validation**: Compiles, Interactor handles task selection

---

### Step 9: Update MainView to Handle Task Taps

**File**: `RIBs/Main/MainView.swift`

1. Add tap gesture to TaskCard
2. Emit task selection event via Observable
3. Update MainViewController to expose `taskTapped` Observable

**Key Code Pattern**:
```swift
struct TaskCard: View {
    let task: Task
    let themeProvider: ThemeProviding
    private var taskTappedObserver: AnyObserver<Task>?
    
    var body: some View {
        VStack {
            // ... existing content
        }
        .onTapGesture {
            taskTappedObserver?.onNext(task)
        }
    }
    
    func onTaskTapped(_ observer: AnyObserver<Task>) -> Self {
        var copy = self
        copy.taskTappedObserver = observer
        return copy
    }
}

final class MainViewController: UIHostingController<MainView>, MainPresentable {
    private let taskTappedSubject = PublishSubject<Task>()
    
    var taskTapped: Observable<Task> { taskTappedSubject.asObservable() }
    
    // In init, wire TaskCard.onTaskTapped to taskTappedSubject
}
```

**Validation**: Compiles, tapping task card triggers navigation

---

### Step 10: Add Localization Strings

**File**: `Localizable.xcstrings`

1. Add strings for:
   - Close button
   - Detail view title (optional)

**Validation**: Compiles, strings available

---

## Testing Checklist

After each step, verify:
- [ ] Code compiles without errors
- [ ] No warnings (address if critical)
- [ ] RIB can be instantiated
- [ ] Modal presentation works
- [ ] Dismissal works (swipe down and close button)
- [ ] Task information displays correctly

## Common Pitfalls

1. **Forgetting to attach/detach child RIB**: Always attach before present, detach after dismiss
2. **Modal presentation style**: Must set `.modalPresentationStyle` before presenting
3. **Swipe down detection**: Use `isBeingDismissed` in `viewDidDisappear`, not `isMovingFromParent`
4. **Multiple TaskDetails open**: Check for existing child before creating new one
5. **Thread safety**: Ensure UI updates on main thread

## Next Steps

After implementation:
1. Run app in simulator
2. Tap on a task card
3. Verify modal sheet opens from bottom
4. Verify task details display correctly
5. Test swipe down dismissal
6. Test close button dismissal
7. Verify only one detail card can be open at a time
