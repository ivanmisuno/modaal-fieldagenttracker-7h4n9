# Tasks: Main Tab Bar Navigation

**Input**: Design documents from `/specs/003-main-tab-bar/`
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

**Purpose**: Project structure verification

- [X] T001 Verify project structure matches plan.md in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: No foundational tasks required - existing infrastructure (Workers, Models) can be reused

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Navigate Between App Sections via Tab Bar (Priority: P1) 🎯 MVP

**Goal**: Display tab bar with four tabs (Main, Calendar, Road Planner, Settings) and enable navigation between them. Extract existing task list functionality to HomeTab and create placeholder tabs for future features.

**Independent Test**: Launch the app and verify that the tab bar appears with all four tabs visible and functional. Tapping each tab should switch to the corresponding section. HomeTab displays task list, placeholder tabs display placeholder content. Delivers core navigation capability enabling access to all major app sections.

### Implementation for User Story 1

#### Step 1: Create Placeholder Tab RIBs

- [X] T002 [US1] Create CalendarTab directory in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/CalendarTab/`
- [X] T003 [P] [US1] Create CalendarTabBuilder.swift with CalendarTabDependency and CalendarTabBuildable protocols in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/CalendarTab/CalendarTabBuilder.swift`
- [X] T004 [P] [US1] Create CalendarTabInteractor.swift with CalendarTabInteractable protocol in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/CalendarTab/CalendarTabInteractor.swift`
- [X] T005 [P] [US1] Create CalendarTabRouter.swift with CalendarTabViewControllable and CalendarTabRouting protocols in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/CalendarTab/CalendarTabRouter.swift`
- [X] T006 [P] [US1] Create CalendarTabView.swift with CalendarTabViewState, CalendarTabView, and CalendarTabViewController in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/CalendarTab/CalendarTabView.swift`
- [X] T007 [US1] Implement CalendarTabComponent with themeProvider in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/CalendarTab/CalendarTabBuilder.swift`
- [X] T008 [US1] Implement CalendarTabBuilder.build(withListener:navigationController:) method in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/CalendarTab/CalendarTabBuilder.swift`
- [X] T009 [US1] Implement CalendarTabInteractor with base Interactor (no Presentable) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/CalendarTab/CalendarTabInteractor.swift`
- [X] T010 [US1] Implement CalendarTabRouter with proper initialization in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/CalendarTab/CalendarTabRouter.swift`
- [X] T011 [US1] Implement CalendarTabViewState with no @Published properties (placeholder) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/CalendarTab/CalendarTabView.swift`
- [X] T012 [US1] Implement CalendarTabView SwiftUI placeholder view with "Calendar" text and calendar icon in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/CalendarTab/CalendarTabView.swift`
- [X] T013 [US1] Implement CalendarTabViewController with UIHostingController in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/CalendarTab/CalendarTabView.swift`

- [X] T014 [US1] Create RoadPlannerTab directory in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/RoadPlannerTab/`
- [X] T015 [P] [US1] Create RoadPlannerTabBuilder.swift with RoadPlannerTabDependency and RoadPlannerTabBuildable protocols in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/RoadPlannerTab/RoadPlannerTabBuilder.swift`
- [X] T016 [P] [US1] Create RoadPlannerTabInteractor.swift with RoadPlannerTabInteractable protocol in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/RoadPlannerTab/RoadPlannerTabInteractor.swift`
- [X] T017 [P] [US1] Create RoadPlannerTabRouter.swift with RoadPlannerTabViewControllable and RoadPlannerTabRouting protocols in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/RoadPlannerTab/RoadPlannerTabRouter.swift`
- [X] T018 [P] [US1] Create RoadPlannerTabView.swift with RoadPlannerTabViewState, RoadPlannerTabView, and RoadPlannerTabViewController in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/RoadPlannerTab/RoadPlannerTabView.swift`
- [X] T019 [US1] Implement RoadPlannerTabComponent with themeProvider in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/RoadPlannerTab/RoadPlannerTabBuilder.swift`
- [X] T020 [US1] Implement RoadPlannerTabBuilder.build(withListener:navigationController:) method in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/RoadPlannerTab/RoadPlannerTabBuilder.swift`
- [X] T021 [US1] Implement RoadPlannerTabInteractor with base Interactor (no Presentable) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/RoadPlannerTab/RoadPlannerTabInteractor.swift`
- [X] T022 [US1] Implement RoadPlannerTabRouter with proper initialization in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/RoadPlannerTab/RoadPlannerTabRouter.swift`
- [X] T023 [US1] Implement RoadPlannerTabViewState with no @Published properties (placeholder) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/RoadPlannerTab/RoadPlannerTabView.swift`
- [X] T024 [US1] Implement RoadPlannerTabView SwiftUI placeholder view with "Road Planner" text and map icon in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/RoadPlannerTab/RoadPlannerTabView.swift`
- [X] T025 [US1] Implement RoadPlannerTabViewController with UIHostingController in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/RoadPlannerTab/RoadPlannerTabView.swift`

- [X] T026 [US1] Create SettingsTab directory in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/SettingsTab/`
- [X] T027 [P] [US1] Create SettingsTabBuilder.swift with SettingsTabDependency and SettingsTabBuildable protocols in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/SettingsTab/SettingsTabBuilder.swift`
- [X] T028 [P] [US1] Create SettingsTabInteractor.swift with SettingsTabInteractable protocol in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/SettingsTab/SettingsTabInteractor.swift`
- [X] T029 [P] [US1] Create SettingsTabRouter.swift with SettingsTabViewControllable and SettingsTabRouting protocols in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/SettingsTab/SettingsTabRouter.swift`
- [X] T030 [P] [US1] Create SettingsTabView.swift with SettingsTabViewState, SettingsTabView, and SettingsTabViewController in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/SettingsTab/SettingsTabView.swift`
- [X] T031 [US1] Implement SettingsTabComponent with themeProvider in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/SettingsTab/SettingsTabBuilder.swift`
- [X] T032 [US1] Implement SettingsTabBuilder.build(withListener:navigationController:) method in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/SettingsTab/SettingsTabBuilder.swift`
- [X] T033 [US1] Implement SettingsTabInteractor with base Interactor (no Presentable) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/SettingsTab/SettingsTabInteractor.swift`
- [X] T034 [US1] Implement SettingsTabRouter with proper initialization in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/SettingsTab/SettingsTabRouter.swift`
- [X] T035 [US1] Implement SettingsTabViewState with no @Published properties (placeholder) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/SettingsTab/SettingsTabView.swift`
- [X] T036 [US1] Implement SettingsTabView SwiftUI placeholder view with "Settings" text and gear icon in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/SettingsTab/SettingsTabView.swift`
- [X] T037 [US1] Implement SettingsTabViewController with UIHostingController in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/SettingsTab/SettingsTabView.swift`

#### Step 2: Create HomeTab RIB

- [X] T038 [US1] Create HomeTab directory in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/`
- [X] T039 [P] [US1] Create HomeTabBuilder.swift with HomeTabDependency and HomeTabBuildable protocols in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/HomeTabBuilder.swift`
- [X] T040 [P] [US1] Create HomeTabInteractor.swift with HomeTabPresentable, HomeTabRouting, and HomeTabInteractable protocols in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/HomeTabInteractor.swift`
- [X] T041 [P] [US1] Create HomeTabRouter.swift with HomeTabViewControllable protocol in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/HomeTabRouter.swift`
- [X] T042 [P] [US1] Create HomeTabView.swift with HomeTabViewState, HomeTabView, and HomeTabViewController in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/HomeTabView.swift`
- [X] T043 [US1] Implement HomeTabComponent with themeProvider, dailyPlannerWorker, and taskDetailsBuilder in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/HomeTabBuilder.swift`
- [X] T044 [US1] Implement HomeTabBuilder.build(withListener:navigationController:) method in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/HomeTabBuilder.swift`
- [X] T045 [US1] Move MainViewState to HomeTabViewState in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/HomeTabView.swift`
- [X] T046 [US1] Move MainView content to HomeTabView (task list, TaskCard, StatusBadge, EmptyStateView) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/HomeTabView.swift`
- [X] T047 [US1] Move MainViewController to HomeTabViewController with HomeTabPresentable implementation in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/HomeTabView.swift`
- [X] T048 [US1] Implement HomeTabInteractor with DailyPlannerWorking, subscribe to tasks, bind to presenter, handle task taps in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/HomeTabInteractor.swift`
- [X] T049 [US1] Implement HomeTabRouter with taskDetailsBuilder, routeToTaskDetails(task:), and routeFromTaskDetails() methods in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/HomeTabRouter.swift`
- [X] T050 [US1] Update HomeTabView to use HomeTabViewState instead of MainViewState in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/HomeTab/HomeTabView.swift`

#### Step 3: Refactor Main RIB to View-less Coordinator

- [X] T051 [US1] Update MainDependency to add homeTabBuilder, calendarTabBuilder, roadPlannerTabBuilder, settingsTabBuilder and remove dailyPlannerWorker, taskDetailsBuilder in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`
- [X] T052 [US1] Update MainComponent to provide tab builders and remove dailyPlannerWorker, taskDetailsBuilder in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`
- [X] T053 [US1] Update MainBuildable to remove navigationController parameter in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`
- [X] T054 [US1] Update MainBuilder.build() to create UITabBarController, build all four tab RIBs, wrap in UINavigationControllers, and set tab bar items in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`
- [X] T055 [US1] Convert MainInteractor from PresentableInteractor to base Interactor, remove presenter dependency and task subscriptions in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainInteractor.swift`
- [X] T056 [US1] Remove MainPresentable protocol and MainRouting routeToTaskDetails/routeFromTaskDetails methods in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainInteractor.swift`
- [X] T057 [US1] Update MainRouter to store UITabBarController, remove taskDetailsBuilder and routeToTaskDetails/routeFromTaskDetails, attach all four tab RIBs in init in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainRouter.swift`
- [X] T058 [US1] Update MainRouter init to accept tab builders and create UITabBarController as viewControllable in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainRouter.swift`
- [X] T059 [US1] Delete MainView.swift file (content moved to HomeTabView) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`

#### Step 4: Update Root Integration

- [X] T060 [US1] Add homeTabBuilder, calendarTabBuilder, roadPlannerTabBuilder, settingsTabBuilder to RootComponent in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Root/RootBuilder.swift`
- [X] T061 [US1] Extend RootComponent to provide tab builders to MainDependency in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Root/RootBuilder.swift`
- [X] T062 [US1] Update RootRouter.routeToMain() to remove NavigationController creation and embed MainRouter's UITabBarController directly in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Root/RootRouter.swift`

#### Step 5: Configure Tab Bar Appearance

- [X] T063 [US1] Configure UITabBarController tab bar items with SF Symbols (house.fill, calendar, map, gear) and titles in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`
- [X] T064 [US1] Set tab bar item titles: "Main", "Calendar", "Road Planner", "Settings" in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`
- [X] T065 [US1] Configure tab bar appearance (colors, styling) using ThemeProvider in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`

**Checkpoint**: At this point, User Story 1 should be fully functional - tab bar displays with four tabs, all tabs are accessible, HomeTab displays task list, placeholder tabs display placeholder content, tab switching works and preserves state.

---

## Phase 4: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect the feature

- [ ] T066 [P] Verify all protocols are marked with `/// sourcery: CreateMock` annotation
- [ ] T067 [P] Verify Rx lifecycle bindings use `.disposeOnDeactivate(interactor:)` for Interactors
- [ ] T068 [P] Verify all tab RIBs properly attach/detach from MainRouter
- [ ] T069 [P] Verify UITabBarController is properly configured with all four tabs
- [ ] T070 [P] Verify each tab maintains independent navigation stack
- [ ] T071 [P] Verify tab state preservation when switching between tabs
- [ ] T072 [P] Verify tab bar visibility (visible on all tabs, hidden on full-screen modals)
- [ ] T073 [P] Verify HomeTab task list functionality works correctly (displays tasks, opens TaskDetails)
- [ ] T074 [P] Code cleanup and refactoring for consistency

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: No tasks - existing infrastructure reused
- **User Story 1 (Phase 3)**: Can start immediately (no foundational dependencies)
- **Polish (Phase 4)**: Depends on User Story 1 completion

### User Story Dependencies

- **User Story 1 (P1)**: No dependencies on other stories - can be implemented independently

### Within User Story 1

- Placeholder tab RIBs (T002-T037) can be created in parallel after scaffolding
- HomeTab RIB (T038-T050) must be created after placeholder tabs (to establish pattern)
- Main RIB refactoring (T051-T059) depends on HomeTab completion
- Root integration (T060-T062) depends on Main RIB refactoring
- Tab bar appearance (T063-T065) depends on Main RIB setup

### Parallel Opportunities

- **Phase 3 (US1)**: 
  - T003-T006, T015-T018, T027-T030 (placeholder tab scaffolding) can run in parallel
  - T007-T013, T019-T025, T031-T037 (placeholder tab implementation) can run in parallel
  - T039-T042 (HomeTab scaffolding) can run in parallel
  - T066-T074 (Polish tasks) can all run in parallel

---

## Parallel Example: User Story 1

```bash
# Launch all placeholder tab scaffolding together:
Task: "Create CalendarTabBuilder.swift with protocols"
Task: "Create CalendarTabInteractor.swift with protocols"
Task: "Create CalendarTabRouter.swift with protocols"
Task: "Create CalendarTabView.swift with ViewState, View, ViewController"
Task: "Create RoadPlannerTabBuilder.swift with protocols"
Task: "Create RoadPlannerTabInteractor.swift with protocols"
Task: "Create RoadPlannerTabRouter.swift with protocols"
Task: "Create RoadPlannerTabView.swift with ViewState, View, ViewController"
Task: "Create SettingsTabBuilder.swift with protocols"
Task: "Create SettingsTabInteractor.swift with protocols"
Task: "Create SettingsTabRouter.swift with protocols"
Task: "Create SettingsTabView.swift with ViewState, View, ViewController"

# After scaffolding, launch placeholder tab implementation:
Task: "Implement CalendarTabComponent and Builder"
Task: "Implement RoadPlannerTabComponent and Builder"
Task: "Implement SettingsTabComponent and Builder"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (no tasks - already complete)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently - verify tab bar appears, all tabs accessible, HomeTab displays task list, placeholder tabs display content, tab switching preserves state
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup → Foundation ready (existing infrastructure)
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Developer A: Placeholder tab RIBs (CalendarTab, RoadPlannerTab, SettingsTab) in parallel
2. Developer B: HomeTab RIB (extract from Main)
3. Developer C: Main RIB refactoring (after HomeTab complete)
4. Developer D: Root integration and tab bar appearance (after Main refactoring)

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- User story should be independently completable and testable
- Placeholder tabs use full RIB structure for consistency and future implementation
- HomeTab preserves all existing task list functionality
- Tab state preservation handled automatically by UIKit (UITabBarController, UINavigationController)
- Commit after each task or logical group
- Stop at checkpoint to validate story independently
- Verify compilation after each task
- Run app in simulator to test after completion
