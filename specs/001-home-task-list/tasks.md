# Tasks: Home Task List

**Input**: Design documents from `/specs/001-home-task-list/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Tests**: Tests are NOT requested in the feature specification, so no test tasks are included.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Path Conventions

- **iOS Project**: `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/`
- Models: `Models/`
- Workers: `Workers/`
- RIBs: `RIBs/`
- Localization: `Localizable.xcstrings`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project structure verification (no new infrastructure needed - using existing RIBs architecture)

- [x] T001 Verify project structure matches plan.md in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core data models that BOTH user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T002 [P] Create TaskStatus enum in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Models/TaskStatus.swift`
- [x] T003 [P] Create Task struct in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Models/Task.swift`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - View Today's Task List on App Start (Priority: P1) 🎯 MVP

**Goal**: Display a list of today's tasks (shops to visit) on the home screen when the app starts, ordered by visiting order, with all required information visible on each task card.

**Independent Test**: Launch the app and verify that today's tasks appear in the correct order with all required information visible (venue name, photo, address, opening hours, planned visit time, status). Works without location services.

### Implementation for User Story 1

- [x] T004 [US1] Create DailyPlannerWorking protocol in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/DailyPlannerWorker.swift`
- [x] T005 [US1] Create DailyPlannerWorker class with mock data (5-10 tasks) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/DailyPlannerWorker.swift`
- [x] T006 [US1] Add dailyPlannerWorker lazy property to RootComponent in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Root/RootBuilder.swift`
- [x] T007 [US1] Add dailyPlannerWorker property to MainDependency protocol in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`
- [x] T008 [US1] Extend RootComponent to conform to MainDependency with dailyPlannerWorker in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Root/RootBuilder.swift`
- [x] T009 [US1] Add dailyPlannerWorker to MainComponent in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`
- [x] T010 [US1] Extract dailyPlannerWorker from component and pass to MainInteractor in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainBuilder.swift`
- [x] T011 [US1] Add tasks Binder to MainPresentable protocol in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainInteractor.swift`
- [x] T012 [US1] Add dailyPlannerWorker property and initializer parameter to MainInteractor in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainInteractor.swift`
- [x] T013 [US1] Subscribe to dailyPlannerWorker.tasks stream and bind to presenter.tasks in MainInteractor.didBecomeActive() in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainInteractor.swift`
- [x] T014 [US1] Add tasks property to MainViewState in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`
- [x] T015 [US1] Implement tasks Binder in MainViewController in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`
- [x] T016 [US1] Create TaskCard SwiftUI component displaying venue name, photo (AsyncImage), address, opening hours, planned visit time, and status in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`
- [x] T017 [US1] Update MainView to display task list using LazyVStack in ScrollView in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`
- [x] T018 [US1] Add empty state view for when no tasks exist in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`
- [x] T019 [US1] Start dailyPlannerWorker in RootInteractor.didBecomeActive() in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Root/RootInteractor.swift`
- [x] T020 [US1] Add localization strings for empty state message and status labels in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Localizable.xcstrings`

**Checkpoint**: At this point, User Story 1 should be fully functional - task list displays with mock data, ordered by visiting order, showing all required information. Can be tested independently without location services.

---

## Phase 4: User Story 2 - Real-Time Distance Updates (Priority: P2)

**Goal**: Distance and estimated travel time to each shop automatically update based on the user's current location as they move throughout their day.

**Independent Test**: Move the device (or simulate location changes) and observe that distance and travel time values update automatically without user interaction. Works independently of US1 (US1 already works, US2 adds location-aware updates).

### Implementation for User Story 2

- [x] T021 [US2] Create LocationServiceWorking protocol in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/LocationServiceWorker.swift`
- [x] T022 [US2] Create LocationServiceWorker class extending Worker in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/LocationServiceWorker.swift`
- [x] T023 [US2] Implement CLLocationManagerDelegate in LocationServiceWorker in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/LocationServiceWorker.swift`
- [x] T024 [US2] Configure CLLocationManager with distanceFilter (100m) and desiredAccuracy in LocationServiceWorker.didStart() in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/LocationServiceWorker.swift`
- [x] T025 [US2] Request "When In Use" location permission in LocationServiceWorker.didStart() in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/LocationServiceWorker.swift`
- [x] T026 [US2] Expose currentLocation Observable stream via BehaviorSubject in LocationServiceWorker in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/LocationServiceWorker.swift`
- [x] T027 [US2] Expose authorizationStatus Observable stream in LocationServiceWorker in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/LocationServiceWorker.swift`
- [x] T028 [US2] Add locationServiceWorker lazy property to RootComponent in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Root/RootBuilder.swift`
- [x] T029 [US2] Update DailyPlannerWorker initializer to accept LocationServiceWorking dependency in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/DailyPlannerWorker.swift`
- [x] T030 [US2] Update DailyPlannerWorker to combine mock tasks with locationService.currentLocation stream using combineLatest in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/DailyPlannerWorker.swift`
- [x] T031 [US2] Implement calculateDistance method in DailyPlannerWorker using CLLocation.distance(from:) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/DailyPlannerWorker.swift`
- [x] T032 [US2] Implement estimateTravelTime method in DailyPlannerWorker using speed-based calculation (50 km/h average) in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/DailyPlannerWorker.swift`
- [x] T033 [US2] Map combined stream to update task distances and travel times in DailyPlannerWorker in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Workers/DailyPlannerWorker.swift`
- [x] T034 [US2] Update DailyPlannerWorker initialization in RootComponent to pass locationServiceWorker dependency in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Root/RootBuilder.swift`
- [x] T035 [US2] Start locationServiceWorker in RootInteractor.didBecomeActive() in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Root/RootInteractor.swift`
- [x] T036 [US2] Update TaskCard to display distance and travel time with "Distance unavailable" fallback when nil in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`
- [x] T037 [US2] Add localization string for "Distance unavailable" in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/Localizable.xcstrings`
- [x] T038 [US2] Format distance display (meters/kilometers) and travel time display (minutes) in TaskCard in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/Main/MainView.swift`

**Checkpoint**: At this point, User Stories 1 AND 2 should both work - task list displays with real-time distance updates as location changes. Distance shows "unavailable" when location services are disabled.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T039 [P] Add Info.plist entry for NSLocationWhenInUseUsageDescription in `src-ios/App/FieldAgentTracker/Info.plist`
- [x] T040 [P] Verify all protocols are marked with `/// sourcery: CreateMock` annotation
- [x] T041 [P] Verify Rx lifecycle bindings use `.disposeOnDeactivate(interactor:)` for Interactors and `.disposeOnStop(self)` for Workers
- [x] T042 [P] Run quickstart.md validation checklist
- [x] T043 [P] Verify UI uses semantic fonts and colors from ThemeProvider throughout
- [x] T044 [P] Verify AsyncImage handles all phases (empty, success, failure) with appropriate placeholders
- [x] T045 [P] Code cleanup and refactoring for consistency

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational completion - Can be implemented independently
- **User Story 2 (Phase 4)**: Depends on Foundational completion - Enhances US1 with location features
- **Polish (Phase 5)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - Enhances US1 but US1 works independently without it

### Within Each User Story

- Models before Workers
- Workers before RIB integration
- RIB integration before UI
- Core implementation before polish

### Parallel Opportunities

- **Phase 2**: T002 and T003 can run in parallel (different files)
- **Phase 3 (US1)**: Most tasks are sequential due to dependencies, but T020 (localization) can be done in parallel with UI tasks
- **Phase 4 (US2)**: T021-T027 (LocationServiceWorker) can be done in parallel with T029-T033 (DailyPlannerWorker updates) after T028 completes
- **Phase 5**: All tasks marked [P] can run in parallel

---

## Parallel Example: User Story 2

```bash
# After T028 completes, these can run in parallel:
Task: "Update DailyPlannerWorker initializer to accept LocationServiceWorking dependency"
Task: "Implement calculateDistance method in DailyPlannerWorker"
Task: "Implement estimateTravelTime method in DailyPlannerWorker"

# These can run in parallel:
Task: "Add Info.plist entry for NSLocationWhenInUseUsageDescription"
Task: "Verify all protocols are marked with `/// sourcery: CreateMock` annotation"
Task: "Verify Rx lifecycle bindings"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently - task list displays with mock data, no location needed
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo (Enhanced with location)
4. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (can work independently)
   - Developer B: User Story 2 (can start after T028, enhances US1)
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- US1 works without location services (mock data only)
- US2 enhances US1 with location-aware distance updates
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Verify compilation after each task
- Run app in simulator to test after US1 and US2 completion
