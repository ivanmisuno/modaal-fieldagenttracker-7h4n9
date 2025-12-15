# Implementation Plan: Main Tab Bar Navigation

**Branch**: `003-main-tab-bar` | **Date**: 2025-12-15 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/003-main-tab-bar/spec.md`

## Summary

This feature converts the existing Main RIB from a view-having RIB (displaying task list) to a view-less RIB that acts as a tab bar coordinator. The implementation includes:

1. **Main RIB Refactoring**: Convert Main RIB from view-having to view-less (TabBar coordinator)
2. **HomeTab RIB Creation**: Extract current task list functionality into a new HomeTab RIB
3. **Placeholder Tab RIBs**: Create CalendarTab, RoadPlannerTab, and SettingsTab RIBs with placeholder content
4. **Tab Bar Integration**: Implement UITabBarController with four tabs, each wrapped in UINavigationController
5. **State Preservation**: Ensure each tab maintains its own state and navigation stack

The feature enables navigation between four main app sections while preserving the existing task list functionality in the HomeTab.

## Technical Context

**Language/Version**: Swift 5.9+
**Primary Dependencies**: 
- RIBs framework (Uber RIBs)
- RxSwift/RxRelay for reactive data streams
- SwiftUI for UI implementation (child tab RIBs)
- UIKit UITabBarController for tab bar container
- SharedUtility for NavigationControllable protocol

**Storage**: No new storage required (existing task data from DailyPlannerWorker)
**Testing**: XCTest (unit tests for Router attach/detach, Interactor logic)
**Target Platform**: iOS 15+
**Project Type**: Mobile (iOS native app)
**Performance Goals**: 
- Tab switching within 0.3 seconds (SC-001)
- Tab state preservation with no data loss (SC-003)
- Smooth tab transitions with preserved navigation stacks

**Constraints**: 
- Must preserve existing Main RIB functionality (task list)
- Each tab must maintain independent navigation stack
- Tab bar must remain visible unless full-screen modal is presented
- No breaking changes to existing Root → Main integration

**Scale/Scope**: 
- 1 view-less RIB (Main - TabBar coordinator)
- 4 view-having RIBs (HomeTab, CalendarTab, RoadPlannerTab, SettingsTab)
- 1 UITabBarController container
- 4 UINavigationController containers (one per tab)

## Constitution Check

_GATE: Must pass before Phase 0 research. Re-check after Phase 1 design._

### Pre-Research Check (Initial)

#### Module Placement
✅ **PASS**: All code lives in `src-ios/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/`
- Main RIB refactoring: `RIBs/Main/`
- New tab RIBs: `RIBs/HomeTab/`, `RIBs/CalendarTab/`, `RIBs/RoadPlannerTab/`, `RIBs/SettingsTab/`
- No code added to `src-ios/App/...`

#### RIB Architecture
✅ **PASS**: 
- Main RIB converted to view-less (TabBar coordinator pattern)
- Child tab RIBs are view-having, use Presenter pattern
- Follows RIBs TabBar coordinator pattern from knowledge base
- Proper attach/detach lifecycle management

#### Dependency Injection
✅ **PASS**:
- Tab builders exposed via MainDependency protocol
- Concrete services extracted from components in Builders
- No `*Dependency` protocols passed to Interactors/ViewControllers
- RootComponent provides tab builders to MainComponent

#### SwiftUI Usage
✅ **PASS**: All new tab RIBs use SwiftUI with UIHostingController presenters

#### Protocol Organization
✅ **PASS**: Following RIBs protocol placement rules:
- `*Dependency`, `*Buildable` in Builder files
- `*Interactable`, `*ViewControllable` in Router files
- `*Routing`, `*Listener`, `*Presentable` in Interactor files
- All protocols marked with `/// sourcery: CreateMock`

#### Navigation and Containers
✅ **PASS**:
- UITabBarController created and owned by MainRouter
- UINavigationController created per tab and passed via DI
- NavigationControllable protocol used (from SharedUtility)
- No implicit navigation controller discovery

### Post-Design Check (After Phase 1)

#### Module Placement
✅ **PASS**: No changes - all code remains in FieldAgentTrackerMain SPM module

#### RIB Architecture
✅ **PASS**: 
- Main RIB design follows view-less coordinator pattern correctly
- HomeTab RIB follows view-having pattern with Presenter
- Placeholder tabs follow view-having pattern
- All RIBs properly structured with correct component separation

#### Dependency Injection
✅ **PASS**:
- Design contracts specify concrete service injection
- No `*Dependency` protocols in Interactor/ViewController initializers
- Tab builders passed via MainDependency
- RootComponent → MainComponent → Tab RIBs dependency flow correct

#### SwiftUI Usage
✅ **PASS**: 
- All tab RIBs use SwiftUI with UIHostingController
- HomeTabView moved from MainView maintains SwiftUI implementation
- Placeholder tabs use SwiftUI

#### Protocol Organization
✅ **PASS**: 
- All protocols placed according to RIBs rules
- Design contracts specify correct protocol locations
- All protocols will be marked with `/// sourcery: CreateMock`

#### Navigation and Containers
✅ **PASS**:
- UITabBarController ownership clearly defined (MainRouter)
- UINavigationController per tab with explicit DI
- NavigationControllable protocol usage specified
- No navigation controller discovery patterns

#### Rx Lifecycle
✅ **PASS**:
- HomeTabInteractor uses `.disposeOnDeactivate(interactor:)` for subscriptions
- No workers owned by MainInteractor (view-less, no long-running streams)
- Placeholder tabs have no Rx subscriptions (static content)

#### RIB Lifecycle
✅ **PASS**:
- All tab RIBs attached in MainRouter initialization
- Proper attachChild/detachChild usage specified
- No strong references to parent RIBs via Listener

## Project Structure

### Documentation (this feature)

```text
specs/003-main-tab-bar/
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
│               │   ├── Main/                    # View-less TabBar coordinator (REFACTORED)
│               │   │   ├── MainBuilder.swift   # TabBar setup, child builder DI
│               │   │   ├── MainInteractor.swift # Tab coordination logic
│               │   │   └── MainRouter.swift     # UITabBarController management
│               │   ├── HomeTab/                 # NEW: Task list RIB (extracted from Main)
│               │   │   ├── HomeTabBuilder.swift
│               │   │   ├── HomeTabInteractor.swift
│               │   │   ├── HomeTabRouter.swift
│               │   │   └── HomeTabView.swift    # SwiftUI: Task list view
│               │   ├── CalendarTab/             # NEW: Calendar placeholder RIB
│               │   │   ├── CalendarTabBuilder.swift
│               │   │   ├── CalendarTabInteractor.swift
│               │   │   ├── CalendarTabRouter.swift
│               │   │   └── CalendarTabView.swift # SwiftUI: Placeholder view
│               │   ├── RoadPlannerTab/          # NEW: Road planner placeholder RIB
│               │   │   ├── RoadPlannerTabBuilder.swift
│               │   │   ├── RoadPlannerTabInteractor.swift
│               │   │   ├── RoadPlannerTabRouter.swift
│               │   │   └── RoadPlannerTabView.swift # SwiftUI: Placeholder view
│               │   └── SettingsTab/            # NEW: Settings placeholder RIB
│               │       ├── SettingsTabBuilder.swift
│               │       ├── SettingsTabInteractor.swift
│               │       ├── SettingsTabRouter.swift
│               │       └── SettingsTabView.swift # SwiftUI: Placeholder view
│               ├── Workers/                     # Existing workers (no changes)
│               │   ├── DailyPlannerWorker.swift
│               │   └── LocationServiceWorker.swift
│               └── Models/                     # Existing models (no changes)
│                   ├── Task.swift
│                   └── TaskStatus.swift
```

**Structure Decision**: 
- Main RIB converted to view-less TabBar coordinator following RIBs pattern
- Task list functionality extracted to HomeTab RIB (view-having)
- Three placeholder tab RIBs created for future implementation
- All RIBs live in FieldAgentTrackerMain SPM module
- No new modules required

## Complexity Tracking

> **No violations identified - all patterns follow RIBs architecture guidelines**

## Research Decisions

### Tab Bar Implementation Pattern

**Decision**: Use UITabBarController owned by MainRouter with child RIBs wrapped in UINavigationControllers

**Rationale**: 
- Follows RIBs TabBar coordinator pattern from knowledge base
- Each tab maintains independent navigation stack
- State preservation handled automatically by UIKit
- Standard iOS navigation pattern

**Alternatives considered**:
- Custom tab bar implementation: Rejected - unnecessary complexity, loses iOS standard behavior
- Single navigation stack: Rejected - doesn't meet requirement for independent tab navigation

### Main RIB Conversion Strategy

**Decision**: Convert Main RIB to view-less coordinator, extract task list to HomeTab RIB

**Rationale**:
- Preserves existing functionality while enabling tab structure
- Follows RIBs view-less coordinator pattern
- Clean separation of concerns (coordination vs. content)
- Enables independent development of each tab

**Alternatives considered**:
- Keep Main as view-having with embedded tabs: Rejected - violates RIBs architecture, harder to maintain
- Create new TabBar RIB above Main: Rejected - unnecessary hierarchy, complicates Root integration

### Tab State Preservation

**Decision**: Rely on UIKit's automatic state preservation for UITabBarController and UINavigationController

**Rationale**:
- UIKit automatically preserves navigation stacks per tab
- No additional state management required
- Standard iOS behavior meets requirements
- Simpler implementation

**Alternatives considered**:
- Custom state management: Rejected - unnecessary, UIKit handles this automatically
- Manual state saving/restoration: Rejected - adds complexity without benefit

### Placeholder Tab Implementation

**Decision**: Create full RIB structure for Calendar, Road Planner, and Settings tabs with placeholder SwiftUI views

**Rationale**:
- Enables tab bar to be fully functional immediately
- Provides structure for future feature implementation
- Maintains consistent architecture across all tabs
- Easy to replace placeholder content with real features

**Alternatives considered**:
- Empty tabs: Rejected - poor UX, doesn't meet "accessible and functional" requirement
- Single placeholder RIB: Rejected - doesn't allow independent tab development

## Design Contracts

### Main RIB (View-less TabBar Coordinator)

**RIB Type**: View-less coordinator

**Protocols**:
- `MainDependency`: Exposes tab builders (HomeTabBuildable, CalendarTabBuildable, RoadPlannerTabBuildable, SettingsTabBuildable)
- `MainBuildable`: Builds MainRouter with tab bar
- `MainInteractable`: Router ↔ Interactor communication
- `MainViewControllable`: UITabBarController view hierarchy management
- `MainRouting`: No routing methods needed (tabs managed by UITabBarController)
- `MainListener`: No listener needed (Root doesn't need callbacks)

**Dependencies**:
- ThemeProvider (for tab bar styling)
- HomeTabBuilder, CalendarTabBuilder, RoadPlannerTabBuilder, SettingsTabBuilder

**Navigation**:
- Owns UITabBarController
- Creates UINavigationController per tab
- Embeds tab view controllers in navigation controllers
- Sets navigation controllers as tab bar view controllers

**Lifecycle**:
- No long-running streams
- No workers owned
- Tab switching handled by UIKit

### HomeTab RIB (View-having)

**RIB Type**: View-having (contains task list)

**Protocols**:
- `HomeTabDependency`: themeProvider, dailyPlannerWorker, taskDetailsBuilder
- `HomeTabBuildable`: Builds HomeTabRouter
- `HomeTabInteractable`: Router ↔ Interactor communication
- `HomeTabViewControllable`: View hierarchy management
- `HomeTabRouting`: routeToTaskDetails(task:), routeFromTaskDetails()
- `HomeTabListener`: No listener (Main doesn't need callbacks)
- `HomeTabPresentable`: tasks: Binder<[Task]>, taskTapped: Observable<Task>

**Dependencies**:
- ThemeProvider
- DailyPlannerWorking
- TaskDetailsBuildable

**Navigation**:
- Receives NavigationControllable via DI
- Can present TaskDetails modals

**Lifecycle**:
- Subscribes to dailyPlannerWorker.tasks
- Uses `.disposeOnDeactivate(interactor:)` for Rx subscriptions

**UI**:
- SwiftUI view with task list (moved from MainView)
- Uses existing TaskCard components

### CalendarTab RIB (View-having - Placeholder)

**RIB Type**: View-having (placeholder)

**Protocols**:
- `CalendarTabDependency`: themeProvider
- `CalendarTabBuildable`: Builds CalendarTabRouter
- `CalendarTabInteractable`: Router ↔ Interactor communication
- `CalendarTabViewControllable`: View hierarchy management
- `CalendarTabRouting`: No routing methods (placeholder)
- `CalendarTabListener`: No listener
- `CalendarTabPresentable`: No presentable needed (static placeholder)

**Dependencies**:
- ThemeProvider

**UI**:
- SwiftUI placeholder view with "Calendar" text and icon

### RoadPlannerTab RIB (View-having - Placeholder)

**RIB Type**: View-having (placeholder)

**Protocols**:
- `RoadPlannerTabDependency`: themeProvider
- `RoadPlannerTabBuildable`: Builds RoadPlannerTabRouter
- `RoadPlannerTabInteractable`: Router ↔ Interactor communication
- `RoadPlannerTabViewControllable`: View hierarchy management
- `RoadPlannerTabRouting`: No routing methods (placeholder)
- `RoadPlannerTabListener`: No listener
- `RoadPlannerTabPresentable`: No presentable needed (static placeholder)

**Dependencies**:
- ThemeProvider

**UI**:
- SwiftUI placeholder view with "Road Planner" text and icon

### SettingsTab RIB (View-having - Placeholder)

**RIB Type**: View-having (placeholder)

**Protocols**:
- `SettingsTabDependency`: themeProvider
- `SettingsTabBuildable`: Builds SettingsTabRouter
- `SettingsTabInteractable`: Router ↔ Interactor communication
- `SettingsTabViewControllable`: View hierarchy management
- `SettingsTabRouting`: No routing methods (placeholder)
- `SettingsTabListener`: No listener
- `SettingsTabPresentable`: No presentable needed (static placeholder)

**Dependencies**:
- ThemeProvider

**UI**:
- SwiftUI placeholder view with "Settings" text and icon

## Data Model

No new data entities required. Existing Task and TaskStatus models are reused by HomeTab RIB.

Tab state is managed by UIKit (UITabBarController and UINavigationController) - no explicit data model needed.

## Integration Points

### Root → Main Integration

**Current State**: RootRouter routes to Main RIB, passing NavigationControllable

**Changes Required**:
- Main RIB no longer needs NavigationControllable (becomes view-less)
- RootRouter embeds MainRouter's UITabBarController directly
- MainRouter's viewControllable is UITabBarController

**Implementation**:
```swift
// RootRouter.routeToMain()
let mainRouter = mainBuilder.build(withListener: interactorInternal)
let tabBarController = mainRouter.viewControllable.uiviewController as! UITabBarController
// Embed tabBarController in root view
```

### Main → HomeTab Integration

**HomeTab receives**:
- NavigationControllable (created by MainRouter)
- DailyPlannerWorking (from RootComponent)
- TaskDetailsBuildable (from RootComponent)
- ThemeProvider (from RootComponent)

**HomeTab functionality**:
- Displays task list (moved from MainView)
- Handles task taps → routes to TaskDetails
- Maintains existing task list behavior

### Main → Placeholder Tabs Integration

**Placeholder tabs receive**:
- NavigationControllable (created by MainRouter)
- ThemeProvider (from RootComponent)

**Placeholder tabs functionality**:
- Display placeholder content
- Ready for future feature implementation

## UI Design

### Tab Bar Appearance

- Standard iOS tab bar at bottom
- Four tabs: Main (home icon), Calendar (calendar icon), Road Planner (map icon), Settings (gear icon)
- Selected tab highlighted with accent color
- Tab labels: "Main", "Calendar", "Road Planner", "Settings"

### Tab Content

- **HomeTab**: Existing task list view (moved from MainView)
- **CalendarTab**: Placeholder view with calendar icon and "Calendar" text
- **RoadPlannerTab**: Placeholder view with map icon and "Road Planner" text
- **SettingsTab**: Placeholder view with gear icon and "Settings" text

### Navigation

- Each tab wrapped in UINavigationController
- Tab bar visible across all tabs
- Tab bar hidden when full-screen modals presented
- Standard iOS tab switching behavior

## Testing Strategy

### Unit Tests

- **MainRouter**: Tab bar setup, child RIB attach/detach
- **HomeTabInteractor**: Task list subscription, task tap handling
- **Placeholder Tab Interactors**: Basic initialization

### Integration Tests

- Tab switching preserves state
- Navigation stacks maintained per tab
- Tab bar visibility with modals

## Assumptions

- Tab bar icons and labels will use SF Symbols and standard iOS appearance
- Placeholder tabs will be replaced with full implementations in future features
- Existing DailyPlannerWorker and LocationServiceWorker continue to function unchanged
- TaskDetails RIB integration remains unchanged (accessed from HomeTab)
