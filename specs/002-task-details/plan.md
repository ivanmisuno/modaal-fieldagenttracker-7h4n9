# Implementation Plan: Task Details

**Branch**: `002-task-details` | **Date**: 2025-01-27 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/002-task-details/spec.md`

**Note**: This template is filled in by the `Plan` command.

## Summary

This feature implements a task detail view that opens as a modal sheet when a user taps on a task card in the home screen. The implementation includes:

1. **TaskDetails RIB**: New view-having RIB displaying comprehensive task information
2. **Modal Presentation**: TaskDetails RIB presented as a modal sheet from the bottom
3. **Parent Integration**: Main RIB routes to TaskDetails RIB on task card tap
4. **Dismissal Handling**: TaskDetails RIB notifies parent via Listener when dismissed (swipe down or close button)

The feature reuses the Task entity from the home task list feature and displays the same information in a larger, more detailed format.

## Technical Context

**Language/Version**: Swift 5.9+
**Primary Dependencies**: 
- RIBs framework (Uber RIBs)
- RxSwift/RxRelay for reactive data streams
- SwiftUI for UI implementation
- UIKit for modal sheet presentation

**Storage**: No storage required (displays data from existing Task entity)
**Testing**: XCTest (unit tests for Interactor logic and Router attach/detach)
**Target Platform**: iOS 15+
**Project Type**: Mobile (iOS native app)
**Performance Goals**: 
- Detail card opens within 0.5 seconds (SC-001)
- Dismissal completes within 0.3 seconds (SC-003)

**Constraints**: 
- Modal sheet presentation (slides up from bottom)
- Swipe down gesture for dismissal
- Only one detail card can be open at a time

**Scale/Scope**: 
- Single new RIB (TaskDetails)
- Child of Main RIB
- Reuses Task model from home task list feature

## Constitution Check

_GATE: Must pass before Phase 0 research. Re-check after Phase 1 design._

### Module Placement
✅ **PASS**: TaskDetails RIB lives in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/`
- Follows SPM-first rule
- No code added to App target

### RIB Architecture
✅ **PASS**: 
- TaskDetails RIB is view-having, uses Presenter pattern
- SwiftUI implementation with UIHostingController
- Proper protocol organization following RIBs rules

### Dependency Injection
✅ **PASS**:
- TaskDetailsBuilder injected into MainRouter via MainDependency
- Task passed as parameter to build method
- Concrete services extracted in Builder (not *Dependency passed to Interactor)

### SwiftUI Usage
✅ **PASS**: TaskDetails RIB uses SwiftUI (`TaskDetailsView`) with UIHostingController presenter

### Protocol Organization
✅ **PASS**: Following established patterns:
- TaskDetailsDependency, TaskDetailsBuildable in Builder file
- TaskDetailsInteractable, TaskDetailsViewControllable in Router file
- TaskDetailsPresentable, TaskDetailsRouting, TaskDetailsListener in Interactor file

### Navigation Pattern
✅ **PASS**: 
- Modal sheet presentation via `viewController.present(..., animated: true)`
- No navigation controller needed (modal presentation)
- Dismissal handled via Listener pattern

## Project Structure

### Documentation (this feature)

```text
specs/002-task-details/
├── plan.md              # This file (Plan phase output)
├── research.md          # Phase 0 output (Plan phase output)
├── data-model.md        # Phase 1 output (Plan phase output)
├── quickstart.md        # Phase 1 output (Plan phase output)
└── tasks.md             # Phase 2 output (Tasks phase output - NOT created by Plan)
```

### Source Code (repository root)

```text
src-ios/
├── Libraries/
│   └── FieldAgentTrackerMain/
│       └── Sources/
│           └── FieldAgentTrackerMain/
│               ├── RIBs/
│               │   ├── Main/
│               │   │   ├── MainBuilder.swift          # Updated: inject TaskDetailsBuilder
│               │   │   ├── MainInteractor.swift       # Updated: handle task tap, route to TaskDetails
│               │   │   ├── MainRouter.swift           # Updated: routeToTaskDetails, routeFromTaskDetails
│               │   │   └── MainView.swift             # Updated: TaskCard tap handling
│               │   └── TaskDetails/                   # NEW RIB
│               │       ├── TaskDetailsBuilder.swift    # NEW: Builder with Task parameter
│               │       ├── TaskDetailsInteractor.swift # NEW: Business logic
│               │       ├── TaskDetailsRouter.swift     # NEW: Router (no navigation controller needed)
│               │       └── TaskDetailsView.swift      # NEW: SwiftUI view with presenter
│               └── Localizable.xcstrings               # Updated: Add detail view strings
└── App/                                                 # No changes
```

**Structure Decision**: 
- TaskDetails RIB added to existing `FieldAgentTrackerMain` SPM module
- Located in `RIBs/TaskDetails/` directory
- Main RIB updated to integrate TaskDetails RIB
- No new Workers or Models needed (reuses Task entity)

## Complexity Tracking

> **No violations identified - all patterns follow established architecture**

## Phase 0: Research & Decisions

See [research.md](./research.md) for detailed research findings.

### Key Decisions

1. **RIB Type**: View-having RIB (displays UI, uses Presenter pattern)
2. **Presentation Style**: Modal sheet (`.pageSheet` or `.formSheet` presentation style)
3. **Dismissal Method**: Swipe down gesture (standard iOS behavior) + close button
4. **Data Flow**: Task passed as parameter to TaskDetailsBuilder.build() method
5. **Parent Integration**: MainRouter presents TaskDetails RIB modally, MainInteractor handles task selection

## Phase 1: Design & Contracts

### Data Model

See [data-model.md](./data-model.md) for complete data model specification.

**Key Entities**:

1. **Task**: Reused from home task list feature
   - No new entities required
   - TaskDetails RIB receives Task as initialization parameter

### RIB Contracts

#### TaskDetailsDependency Protocol

```swift
protocol TaskDetailsDependency: Dependency {
    var themeProvider: ThemeProviding { get }
}
```

#### TaskDetailsBuildable Protocol

```swift
protocol TaskDetailsBuildable: Buildable {
    func build(withListener listener: TaskDetailsListener, task: Task) -> TaskDetailsRouting
}
```

#### TaskDetailsPresentable Protocol

```swift
protocol TaskDetailsPresentable: Presentable {
    // Interactor → UI
    var task: Binder<Task> { get }
    
    // UI → Interactor
    var closeTapped: Observable<Void> { get }
    var backTapped: Observable<Void> { get } // For swipe down dismissal
}
```

#### TaskDetailsRouting Protocol

```swift
protocol TaskDetailsRouting: ViewableRouting {
    // No routing methods needed (no child RIBs)
}
```

#### TaskDetailsListener Protocol

```swift
protocol TaskDetailsListener: AnyObject {
    func taskDetailsDidClose()
}
```

#### MainRouting Protocol (Updated)

```swift
protocol MainRouting: ViewableRouting {
    func routeToTaskDetails(task: Task)
    func routeFromTaskDetails()
}
```

#### MainPresentable Protocol (Updated)

```swift
protocol MainPresentable: Presentable {
    var tasks: Binder<[Task]> { get }
    var taskTapped: Observable<Task> { get } // NEW: Task selection event
}
```

### Integration Points

1. **MainComponent**: Receives TaskDetailsBuilder via MainDependency
   ```swift
   protocol MainDependency: Dependency {
       var themeProvider: ThemeProviding { get }
       var dailyPlannerWorker: DailyPlannerWorking { get }
       var taskDetailsBuilder: TaskDetailsBuildable { get } // NEW
   }
   ```

2. **MainBuilder**: Extracts TaskDetailsBuilder from Component, passes to Router
   ```swift
   let router = MainRouter(
       taskDetailsBuilder: TaskDetailsBuilder(dependency: component),
       // ... other dependencies
   )
   ```

3. **MainRouter**: Presents TaskDetails RIB modally
   ```swift
   func routeToTaskDetails(task: Task) {
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
   ```

4. **MainInteractor**: Subscribes to task tap events, requests routing
   ```swift
   presenter.taskTapped
       .subscribe(onNext: { [router] task in
           router?.routeToTaskDetails(task: task)
       })
       .disposeOnDeactivate(interactor: self)
   ```

5. **TaskDetailsInteractor**: Subscribes to close/back events, notifies parent
   ```swift
   presenter.closeTapped
       .merge(with: presenter.backTapped)
       .subscribe(onNext: { [listener] in
           listener?.taskDetailsDidClose()
       })
       .disposeOnDeactivate(interactor: self)
   ```

6. **MainInteractor**: Implements TaskDetailsListener, requests dismissal
   ```swift
   func taskDetailsDidClose() {
       router?.routeFromTaskDetails()
   }
   ```

### UI Design

#### TaskDetailsViewState

```swift
final class TaskDetailsViewState: ObservableObject {
    @Published var task: Task?
}
```

#### TaskDetailsView

- ScrollView with VStack for task details
- Large image (AsyncImage from Shutterstock URL)
- Venue name (title1 font)
- Address (bodyRegular font)
- Opening hours (subheadRegular font)
- Distance and travel time (bodyMedium font, highlighted)
- Planned visit time (footnoteRegular font)
- Status badge (visual indicator with color)
- Close button in navigation bar or toolbar
- Swipe down gesture enabled (standard iOS modal sheet behavior)

### Quick Start Guide

See [quickstart.md](./quickstart.md) for implementation sequence and key code patterns.

## Phase 2: Implementation Tasks

_This section will be populated by the Tasks phase. Not created during Plan phase._

## Notes

- TaskDetails RIB is a child of Main RIB
- Modal sheet uses `.pageSheet` presentation style with detents (medium and large) on iOS 15+
- Swipe down gesture is handled by iOS automatically for modal sheets
- Close button provides explicit dismissal option
- TaskDetails RIB receives Task as a parameter (not via Worker stream)
- Real-time distance updates: TaskDetails can subscribe to DailyPlannerWorker.tasks stream and filter for the current task, or receive updated Task via Binder from parent
- Only one TaskDetails RIB can be open at a time (MainRouter replaces if already open)
