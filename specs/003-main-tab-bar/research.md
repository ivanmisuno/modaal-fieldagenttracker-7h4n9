# Research: Main Tab Bar Navigation

**Feature**: 003-main-tab-bar
**Date**: 2025-12-15

## Research Decisions

### Decision 1: Tab Bar Implementation Pattern

**Decision**: Use UITabBarController owned by MainRouter with child RIBs wrapped in UINavigationControllers

**Rationale**: 
- Follows RIBs TabBar coordinator pattern documented in ios-RIBs.md
- UITabBarController provides automatic state preservation per tab
- Each tab wrapped in UINavigationController maintains independent navigation stack
- Standard iOS navigation pattern ensures familiar UX
- UIKit handles tab switching and state management automatically

**Alternatives considered**:
- **Custom tab bar implementation**: Rejected - adds unnecessary complexity, loses iOS standard behavior and accessibility features
- **Single navigation stack shared across tabs**: Rejected - doesn't meet requirement FR-010 for independent tab functionality
- **SwiftUI TabView**: Rejected - doesn't integrate well with RIBs architecture and UINavigationController requirements

**References**:
- ios-RIBs.md: "Main RIB (Tab Bar Coordinator)" section
- ios-RIBs.md: "View-less RIB Patterns" section

### Decision 2: Main RIB Conversion Strategy

**Decision**: Convert Main RIB from view-having to view-less coordinator, extract task list functionality to HomeTab RIB

**Rationale**:
- Preserves existing functionality (task list) while enabling tab structure
- Follows RIBs view-less coordinator pattern for container RIBs
- Clean separation of concerns: Main coordinates tabs, HomeTab displays content
- Enables independent development and testing of each tab
- Maintains existing Root → Main integration pattern (minimal changes)

**Alternatives considered**:
- **Keep Main as view-having with embedded tabs**: Rejected - violates RIBs architecture principles, makes Main RIB too complex, harder to maintain
- **Create new TabBar RIB above Main**: Rejected - adds unnecessary hierarchy level, complicates Root integration, breaks existing patterns
- **Keep Main unchanged, add tabs as siblings**: Rejected - doesn't meet requirement for tab bar navigation structure

**References**:
- ios-RIBs.md: "View-less RIB Patterns" section
- ios-RIBs.md: "Container RIBs: Tab coordinators using ViewableRouter + UITabBarController"

### Decision 3: Tab State Preservation

**Decision**: Rely on UIKit's automatic state preservation for UITabBarController and UINavigationController

**Rationale**:
- UITabBarController automatically preserves navigation stacks per tab
- UINavigationController maintains view controller stack per tab
- No additional state management code required
- Standard iOS behavior meets all state preservation requirements (FR-007, SC-003)
- Simpler implementation reduces complexity and potential bugs

**Alternatives considered**:
- **Custom state management with explicit saving/restoration**: Rejected - unnecessary complexity, UIKit handles this automatically, adds maintenance burden
- **Manual state tracking in Interactor**: Rejected - duplicates UIKit functionality, error-prone, doesn't improve on standard behavior

**References**:
- iOS UIKit documentation: UITabBarController state preservation
- RIBs architecture: View-less coordinators rely on container controllers for state

### Decision 4: Placeholder Tab Implementation

**Decision**: Create full RIB structure for Calendar, Road Planner, and Settings tabs with placeholder SwiftUI views

**Rationale**:
- Enables tab bar to be fully functional immediately (meets SC-004)
- Provides consistent architecture across all tabs
- Makes it easy to replace placeholder content with real features later
- Maintains RIBs patterns from the start (no refactoring needed)
- Placeholder views provide better UX than empty tabs

**Alternatives considered**:
- **Empty tabs with no content**: Rejected - poor UX, doesn't meet "accessible and functional" requirement (SC-004)
- **Single placeholder RIB reused for all tabs**: Rejected - doesn't allow independent tab development, violates RIBs separation of concerns
- **Skip placeholder tabs, implement only HomeTab**: Rejected - doesn't meet spec requirement for four tabs (FR-001, FR-004, FR-005, FR-006)

**References**:
- Feature spec: FR-004, FR-005, FR-006 require Calendar, Road Planner, and Settings tabs
- RIBs architecture: Each tab should be independent RIB for proper separation

### Decision 5: Navigation Controller Per Tab

**Decision**: Create separate UINavigationController for each tab, passed via DI to child RIBs

**Rationale**:
- Each tab maintains independent navigation stack (meets FR-010)
- Follows RIBs Navigation Controller Access Rules: explicit DI, no discovery
- Enables each tab to push/pop view controllers independently
- Supports future features that may need navigation within tabs
- Matches pattern from RootRouter.routeToMain() which creates NavigationController

**Alternatives considered**:
- **Shared navigation controller**: Rejected - doesn't meet requirement for independent tab navigation (FR-010)
- **No navigation controllers for placeholder tabs**: Rejected - inconsistent architecture, makes future implementation harder
- **Discover navigation controller from view hierarchy**: Rejected - violates RIBs Navigation Controller Access Rules

**References**:
- ios-RIBs.md: "Navigation Controller Access Rules" section
- ios-RIBs.md: "Parent-owned UINavigationController DI" pattern
- RootRouter.routeToMain() implementation pattern

### Decision 6: Tab Bar Icons and Labels

**Decision**: Use SF Symbols for tab icons, standard iOS tab bar appearance

**Rationale**:
- SF Symbols provide consistent, scalable icons
- Standard iOS appearance ensures familiar UX
- No custom design assets required
- Easy to update if design requirements change

**Alternatives considered**:
- **Custom icon assets**: Rejected - adds complexity, not specified in requirements, can be added later if needed
- **Text-only tabs**: Rejected - poor UX, doesn't follow iOS design guidelines

**References**:
- iOS Human Interface Guidelines: Tab bar design
- Feature spec assumptions: "Tab bar icons and labels will be provided/designed as part of this feature or in a follow-up design task"

## Technical Constraints

- Must preserve existing DailyPlannerWorker and LocationServiceWorker functionality
- Must maintain TaskDetails RIB integration (now accessed from HomeTab instead of Main)
- RootRouter integration must be updated to work with view-less Main RIB
- No breaking changes to existing models (Task, TaskStatus)

## Integration Points

- **Root → Main**: RootRouter embeds MainRouter's UITabBarController (instead of NavigationController)
- **Main → HomeTab**: HomeTab receives NavigationControllable, DailyPlannerWorking, TaskDetailsBuildable
- **Main → Placeholder Tabs**: Placeholder tabs receive NavigationControllable, ThemeProvider

## Open Questions Resolved

All technical decisions made. No [NEEDS CLARIFICATION] markers remain.
