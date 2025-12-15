# Research & Technical Decisions: Task Details

**Feature**: 002-task-details  
**Date**: 2025-01-27  
**Phase**: 0 (Research)

## Research Questions

### 1. Modal Sheet Presentation in RIBs

**Question**: How to present a view controller as a modal sheet from the bottom in RIBs architecture?

**Research**:
- UIKit provides `modalPresentationStyle` property on UIViewController
- `.pageSheet` is the standard iOS modal sheet style (slides up from bottom)
- iOS 15+ supports `UISheetPresentationController` with detents (medium, large)
- Router presents child view controller via `viewController.present(..., animated: true)`
- Must attach child RIB before presenting

**Decision**: Use `.pageSheet` presentation style with detents on iOS 15+
- **Rationale**: 
  - Standard iOS modal sheet behavior
  - Supports swipe down dismissal automatically
  - Detents allow flexible sizing (medium/large)
  - Follows iOS design guidelines
- **Alternatives Considered**:
  - `.formSheet`: Rejected (smaller, less flexible)
  - `.fullScreen`: Rejected (doesn't match "card opens" requirement)
  - Custom presentation: Rejected (unnecessary complexity)

**Implementation**:
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

---

### 2. Dismissal Handling Pattern

**Question**: How to handle modal sheet dismissal (swipe down and close button) in RIBs?

**Research**:
- iOS automatically handles swipe down gesture for modal sheets
- Need to detect dismissal to detach child RIB
- Two approaches: viewDidDisappear detection or explicit close button
- RIBs pattern: Use Listener to notify parent, parent Router detaches

**Decision**: Use both swipe down detection (viewDidDisappear) and explicit close button
- **Rationale**:
  - Swipe down is standard iOS behavior (automatic)
  - Close button provides explicit dismissal option
  - Both trigger same dismissal flow via Listener
  - Follows RIBs pattern for child → parent communication
- **Alternatives Considered**:
  - Only swipe down: Rejected (users may want explicit close button)
  - Only close button: Rejected (swipe down is standard iOS UX)

**Implementation Pattern**:
```swift
// TaskDetailsViewController
override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isBeingDismissed {
        backSubject.onNext(())
    }
}

// TaskDetailsInteractor
presenter.closeTapped
    .merge(with: presenter.backTapped)
    .subscribe(onNext: { [listener] in
        listener?.taskDetailsDidClose()
    })
    .disposeOnDeactivate(interactor: self)
```

---

### 3. Task Data Passing

**Question**: How should Task data be passed to TaskDetails RIB?

**Research**:
- RIBs pattern: Pass data as parameters to Builder.build() method
- Alternative: Subscribe to Worker stream and filter
- Task is immutable value type (struct)
- No need for real-time updates in detail view (can receive updated Task if needed)

**Decision**: Pass Task as parameter to TaskDetailsBuilder.build()
- **Rationale**:
  - Follows RIBs pattern (data as build parameters)
  - Simple and explicit
  - Task is value type, safe to pass
  - No need for complex stream filtering
- **Alternatives Considered**:
  - Worker stream subscription: Rejected (unnecessary complexity for static data)
  - Shared state: Rejected (violates RIBs isolation principles)

**Implementation**:
```swift
protocol TaskDetailsBuildable: Buildable {
    func build(withListener listener: TaskDetailsListener, task: Task) -> TaskDetailsRouting
}
```

---

### 4. Real-Time Distance Updates in Detail View

**Question**: Should TaskDetails RIB receive real-time distance updates?

**Research**:
- Home task list already has real-time updates via DailyPlannerWorker
- TaskDetails shows same Task data
- Options: Subscribe to Worker stream, receive updates via Binder, or static snapshot

**Decision**: Receive Task updates via Binder from parent (optional enhancement)
- **Rationale**:
  - Simplest approach: Parent can update TaskDetails when Task changes
  - Maintains single source of truth (DailyPlannerWorker)
  - Can be added later if needed
  - For MVP: Static Task snapshot is sufficient
- **Alternatives Considered**:
  - Direct Worker subscription: Rejected (violates RIBs hierarchy, parent should own Worker)
  - Static snapshot: Accepted for MVP (simpler, meets requirements)

**Implementation** (Optional for future):
```swift
// MainInteractor can update TaskDetails when task changes
// For MVP: TaskDetails receives Task at build time, no updates needed
```

---

### 5. RIB Location and Module

**Question**: Where should TaskDetails RIB be located?

**Research**:
- Module placement rules: All RIBs in `FieldAgentTrackerMain` SPM module
- Directory structure: `RIBs/TaskDetails/`
- TaskDetails is a child of Main RIB
- No separate module needed (simple feature)

**Decision**: Place TaskDetails RIB in `RIBs/TaskDetails/` under FieldAgentTrackerMain module
- **Rationale**:
  - Follows module placement rules
  - TaskDetails is a child of Main RIB (logical grouping)
  - No separate module needed (not complex enough)
  - Consistent with existing RIB structure
- **Alternatives Considered**:
  - Separate SPM module: Rejected (unnecessary complexity for single RIB)
  - Under Main/ subdirectory: Rejected (TaskDetails is separate RIB, not Main subcomponent)

---

## Summary of Decisions

| Decision Area | Choice | Rationale |
|--------------|--------|-----------|
| Presentation Style | Modal sheet (.pageSheet) | Standard iOS behavior, supports swipe down |
| Dismissal Method | Swipe down + close button | Standard iOS UX + explicit option |
| Data Passing | Task as build parameter | Follows RIBs pattern, simple and explicit |
| Distance Updates | Static snapshot (MVP) | Simpler, can enhance later if needed |
| RIB Location | RIBs/TaskDetails/ in Main module | Follows module rules, logical grouping |

## Open Questions Resolved

✅ All research questions resolved. No [NEEDS CLARIFICATION] markers remain.

## References

- [RIBs Router Pattern](knowledge/ios-RIBs.md#router-pattern-view-hierarchy-only)
- [RIBs Lifecycle Management](knowledge/ios-RIBs.md#rib-lifecycle-attachdetach)
- [iOS Modal Presentation](https://developer.apple.com/documentation/uikit/view_controllers/presenting_view_controllers_using_defines_presentation_context)
- [UISheetPresentationController](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller)
