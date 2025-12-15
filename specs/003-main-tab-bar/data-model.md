# Data Model: Main Tab Bar Navigation

**Feature**: 003-main-tab-bar
**Date**: 2025-12-15

## Overview

This feature does not introduce new data entities. It refactors the RIB structure to support tab bar navigation while reusing existing data models.

## Existing Entities (Reused)

### Task

**Source**: Feature 001-home-task-list

**Description**: Represents a shop visit scheduled for today.

**Properties**:
- `id: UUID` - Unique identifier
- `venueName: String` - Name of the venue/shop
- `address: String` - Venue address
- `openingHours: String` - Opening hours information
- `plannedVisitTime: Date` - Planned visit time
- `status: TaskStatus` - Current task status
- `visitingOrder: Int` - Order in visiting sequence
- `photoURL: URL` - Photo of front entrance
- `location: CLLocationCoordinate2D` - Venue coordinates
- `distanceFromCurrentLocation: Double?` - Calculated distance (optional)
- `estimatedTravelTime: TimeInterval?` - Estimated travel time (optional)

**Usage**: Used by HomeTab RIB to display task list (moved from Main RIB).

### TaskStatus

**Source**: Feature 001-home-task-list

**Description**: Enumeration of possible task statuses.

**Values**:
- `planned` - Task is planned
- `enRoute` - Agent is en route to location
- `inProgress` - Task is in progress
- `done` - Task is completed
- `cancelled` - Task is cancelled
- `cantComplete` - Task cannot be completed

**Usage**: Used by HomeTab RIB for task status display.

## Tab State Management

**Note**: Tab state (selected tab, navigation stacks) is managed by UIKit's UITabBarController and UINavigationController. No explicit data model is required.

**State Preservation**:
- UITabBarController automatically preserves selected tab
- Each UINavigationController maintains its own view controller stack
- Tab content state preserved by child RIBs (e.g., HomeTab maintains task list scroll position)

## Data Flow

### HomeTab Data Flow

```
DailyPlannerWorker (Rx stream)
  ↓
HomeTabInteractor (subscribes to tasks)
  ↓
HomeTabPresentable (Binder<[Task]>)
  ↓
HomeTabViewState (@Published var tasks: [Task])
  ↓
HomeTabView (SwiftUI displays tasks)
```

### Placeholder Tabs

No data flow required - static placeholder content.

## Relationships

- **Main RIB** (coordinator) → **HomeTab RIB** (displays Task entities)
- **HomeTab RIB** → **TaskDetails RIB** (displays single Task entity)
- **DailyPlannerWorker** → **HomeTab RIB** (provides Task stream)

## Validation Rules

No new validation rules. Existing Task validation from Feature 001 applies.

## State Transitions

No new state transitions. Tab switching is handled by UIKit (UITabBarController).
