# Tasks: Task Details

**Input**: Design documents from `/specs/002-task-details/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Tests**: Tests are NOT requested in the feature specification, so no test tasks are included.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1)
- Include exact file paths in descriptions

## Path Conventions

- **iOS Project**: `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/`
- RIBs: `RIBs/`
- Localization: `Localizable.xcstrings`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project structure verification (no new infrastructure needed - reusing existing Task entity)

- [ ] T001 Verify project structure matches plan.md in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: No foundational tasks required - Task entity already exists from home task list feature

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - View Task Details (Priority: P1) 🎯 MVP

**Goal**: Display comprehensive task information in a modal sheet when user taps on a task card in the home screen task list.

**Independent Test**: Tap on any task card in the home screen and verify that a detail card opens as a modal sheet displaying all task information. Can be fully tested independently of other features.

### Implementation for User Story 1

- [X] T002 [US1] Create TaskDetails directory in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/`
- [X] T003 [P] [US1] Create TaskDetailsBuilder.swift with TaskDetailsDependency and TaskDetailsBuildable protocols in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/TaskDetailsBuilder.swift`
- [X] T004 [P] [US1] Create TaskDetailsInteractor.swift with TaskDetailsPresentable, TaskDetailsRouting, and TaskDetailsListener protocols in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/TaskDetailsInteractor.swift`
- [X] T005 [P] [US1] Create TaskDetailsRouter.swift with TaskDetailsInteractable and TaskDetailsViewControllable protocols in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/TaskDetailsRouter.swift`
- [X] T006 [P] [US1] Create TaskDetailsView.swift with TaskDetailsViewState, TaskDetailsView, and TaskDetailsViewController in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/TaskDetailsView.swift`
- [X] T007 [US1] Implement TaskDetailsComponent with themeProvider in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/TaskDetailsBuilder.swift`
- [X] T008 [US1] Implement TaskDetailsBuilder.build(withListener:task:) method in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/TaskDetailsBuilder.swift`
- [X] T009 [US1] Implement TaskDetailsInteractor with Task parameter, bind task to presenter, and subscribe to close/back events in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/TaskDetailsInteractor.swift`
- [X] T010 [US1] Implement TaskDetailsRouter with proper initialization in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/TaskDetailsRouter.swift`
- [X] T011 [US1] Implement TaskDetailsViewState with @Published task property in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/TaskDetailsView.swift`
- [X] T012 [US1] Implement TaskDetailsView SwiftUI view displaying all task information (venue name, photo, address, opening hours, distance, travel time, planned visit time, status) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/TaskDetailsView.swift`
- [X] T013 [US1] Implement TaskDetailsViewController with task Binder, closeTapped and backTapped Observables, and viewDidDisappear dismissal detection in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/TaskDetailsView.swift`
- [X] T014 [US1] Add close button to TaskDetailsView toolbar in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/TaskDetails/TaskDetailsView.swift`
- [X] T015 [US1] Add taskDetailsBuilder property to MainDependency protocol in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`
- [X] T016 [US1] Extend RootComponent to provide TaskDetailsBuilder in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Root/RootBuilder.swift`
- [X] T017 [US1] Add taskDetailsBuilder to MainComponent in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`
- [X] T018 [US1] Extract taskDetailsBuilder from component and pass to MainRouter initializer in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`
- [X] T019 [US1] Add taskDetailsBuilder property to MainRouter in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainRouter.swift`
- [X] T020 [US1] Add routeToTaskDetails(task:) and routeFromTaskDetails() methods to MainRouting protocol in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainInteractor.swift`
- [X] T021 [US1] Implement routeToTaskDetails(task:) method in MainRouter with modal sheet presentation (.pageSheet style, detents on iOS 15+) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainRouter.swift`
- [X] T022 [US1] Implement routeFromTaskDetails() method in MainRouter with dismiss and detachChild in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainRouter.swift`
- [X] T023 [US1] Add taskTapped Observable to MainPresentable protocol in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainInteractor.swift`
- [X] T024 [US1] Subscribe to presenter.taskTapped in MainInteractor.didBecomeActive() and request routing to TaskDetails in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainInteractor.swift`
- [X] T025 [US1] Implement TaskDetailsListener protocol in MainInteractor with taskDetailsDidClose() method in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainInteractor.swift`
- [X] T026 [US1] Add taskTappedSubject PublishSubject to MainViewController in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`
- [X] T027 [US1] Implement taskTapped Observable in MainViewController exposing taskTappedSubject in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`
- [X] T028 [US1] Add onTaskTapped method to TaskCard SwiftUI view accepting AnyObserver<Task> in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`
- [X] T029 [US1] Add onTapGesture to TaskCard that emits task via taskTappedObserver in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`
- [X] T030 [US1] Wire TaskCard.onTaskTapped to taskTappedSubject in MainView ForEach loop in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`
- [X] T031 [US1] Add localization strings for close button in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Localizable.xcstrings` (Note: Close button uses SF Symbol, no localization needed)

**Checkpoint**: At this point, User Story 1 should be fully functional - tapping a task card opens a modal sheet with task details, and the sheet can be dismissed via swipe down or close button.

---

## Phase 4: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect the feature

- [X] T032 [P] Verify all protocols are marked with `/// sourcery: CreateMock` annotation (Verified: All TaskDetails protocols marked)
- [X] T033 [P] Verify Rx lifecycle bindings use `.disposeOnDeactivate(interactor:)` for Interactors (Verified: TaskDetailsInteractor uses disposeOnDeactivate)
- [X] T034 [P] Verify modal sheet presentation style is correctly configured (.fullScreen for extended top presentation)
- [X] T035 [P] Verify TaskDetails RIB properly attaches/detaches from MainRouter (Verified: attachChild/detachChild implemented correctly)
- [X] T036 [P] Verify only one TaskDetails RIB can be open at a time (replaces existing if already open) (Verified: routeToTaskDetails checks and dismisses existing)
- [X] T037 [P] Verify UI uses semantic fonts and colors from ThemeProvider throughout TaskDetailsView (Verified: All UI uses ThemeProvider)
- [X] T038 [P] Verify AsyncImage handles all phases (empty, success, failure) with appropriate placeholders in TaskDetailsView (Verified: All phases handled)
- [X] T039 [P] Code cleanup and refactoring for consistency (Completed: UI improvements applied, code follows patterns)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: No tasks - Task entity already exists
- **User Story 1 (Phase 3)**: Can start immediately (no foundational dependencies)
- **Polish (Phase 4)**: Depends on User Story 1 completion

### User Story Dependencies

- **User Story 1 (P1)**: No dependencies on other stories - can be implemented independently

### Within User Story 1

- RIB scaffolding (T002-T006) can be done in parallel
- Builder implementation (T007-T008) before Interactor/Router/View
- Interactor, Router, View implementation (T009-T013) can be done in parallel after Builder
- Parent integration (T015-T022) must be sequential
- UI integration (T023-T030) must be sequential
- Localization (T031) can be done in parallel with UI work

### Parallel Opportunities

- **Phase 3 (US1)**: 
  - T003, T004, T005, T006 can run in parallel (different files, RIB scaffolding)
  - T009, T010, T011 can run in parallel after T008 (different files)
  - T032-T039 (Polish tasks) can all run in parallel

---

## Parallel Example: User Story 1

```bash
# Launch all RIB scaffolding tasks together:
Task: "Create TaskDetailsBuilder.swift with protocols"
Task: "Create TaskDetailsInteractor.swift with protocols"
Task: "Create TaskDetailsRouter.swift with protocols"
Task: "Create TaskDetailsView.swift with ViewState, View, ViewController"

# After Builder is complete, launch implementation tasks:
Task: "Implement TaskDetailsInteractor with Task parameter"
Task: "Implement TaskDetailsRouter with proper initialization"
Task: "Implement TaskDetailsViewState and TaskDetailsView"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (no tasks - already complete)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently - tap task card, verify modal sheet opens, verify dismissal works
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup → Foundation ready (Task entity exists)
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Developer A: RIB scaffolding (T003-T006) in parallel
2. Developer B: Builder implementation (T007-T008)
3. Developer C: Interactor/Router/View implementation (T009-T013) after Builder
4. Developer D: Parent integration (T015-T022) after RIB is complete
5. Developer E: UI integration (T023-T030) after parent integration

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- User story should be independently completable and testable
- Task entity reused from home task list feature (001-home-task-list)
- Modal sheet presentation uses .pageSheet style with iOS 15+ detents
- Swipe down dismissal handled automatically by iOS, detected via viewDidDisappear
- Close button provides explicit dismissal option
- Only one TaskDetails RIB can be open at a time (MainRouter replaces if already open)
- Commit after each task or logical group
- Stop at checkpoint to validate story independently
- Verify compilation after each task
- Run app in simulator to test after completion
