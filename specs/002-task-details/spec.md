# Feature Specification: Task Details

**Feature Name**: `002-task-details`
**Created**: 2025-01-27
**Status**: Draft
**Input**: User input:

```
Create a feature specification.
Feature name: Show task/shop details
User stories: When user taps on the shop, a card opens with the details of the task.
```

## User Scenarios & Testing _(mandatory)_

### User Story 1 - View Task Details (Priority: P1)

When a field agent taps on a task card in the home screen task list, a detail card opens displaying comprehensive information about the selected task/shop. This allows agents to review all relevant details before visiting the location, helping them prepare for the visit and understand what to expect.

**Why this priority**: This is the core value proposition - agents need to access detailed information about each task to make informed decisions and prepare for their visits. Without this, agents can only see summary information on the list view.

**Independent Test**: Can be fully tested by tapping on any task card in the home screen and verifying that a detail card opens displaying all task information. Delivers immediate access to comprehensive task details.

**Acceptance Scenarios**:

1. **Given** the home screen is displaying the task list, **When** the user taps on a task card, **Then** a detail card opens displaying all task information
2. **Given** the detail card is open, **When** viewing the card, **Then** it displays: venue name, photo, address, opening hours, travel distance/time, planned visit time, and status
3. **Given** the detail card is open, **When** the user taps a dismiss/close action, **Then** the detail card closes and returns to the task list
4. **Given** the user taps on different task cards, **When** opening detail cards, **Then** each card displays the correct information for the selected task

---

### Edge Cases

- What happens when the user taps on a task card while another detail card is already open?
  - System closes the previous detail card and opens the new one, or replaces the current detail card content
- How does the system handle rapid tapping on multiple task cards?
  - System responds to the most recent tap, opening the detail card for the last selected task
- What happens when task data is missing or incomplete?
  - System displays available information and uses placeholder content (e.g., placeholder image, "Information not available") for missing fields
- How does the system handle the detail card when the app is backgrounded?
  - System maintains the detail card state when returning to foreground, or closes it and returns to list view (reasonable default: maintain state)
- What happens when the user rotates the device while viewing the detail card?
  - Detail card adapts to the new orientation and remains functional

## Requirements _(mandatory)_

### Functional Requirements

- **FR-001**: System MUST open a detail card as a modal sheet (presented from the bottom) when the user taps on a task card in the home screen task list
- **FR-002**: System MUST display the following information in the detail card:
  - Venue/shop name
  - Photo of the front entrance
  - Venue address
  - Opening hours
  - Travel distance from current location (if available)
  - Estimated travel time from current location (if available)
  - Planned visit time
  - Task status (Planned / En route / In progress / Done / Cancelled / Can't complete)
- **FR-003**: System MUST allow the user to dismiss/close the detail card (via swipe down gesture or close button) and return to the task list
- **FR-004**: System MUST display the correct task information for the selected task
- **FR-005**: System MUST handle cases where location information is unavailable by showing appropriate fallback states (e.g., "Distance unavailable")
- **FR-006**: System MUST update distance and travel time in real-time in the detail card if location services are available (inherits from home task list feature)
- **FR-007**: System MUST display task information using the same data source as the home task list (ensures consistency)

### Key Entities _(include if feature involves data)_

- **Task**: Represents a shop visit scheduled for today. Key attributes: venue name, address, opening hours, planned visit time, status, visiting order position, front entrance photo, location coordinates, distance from current location, estimated travel time. Relationships: belongs to today's schedule, has a status, has a planned visiting order. (Reuses entity from home task list feature)

## Success Criteria _(mandatory)_

### Measurable Outcomes

- **SC-001**: Users can open a task detail card within 0.5 seconds of tapping a task card
- **SC-002**: Detail card displays all required information (name, photo, address, opening hours, distance, time, planned visit time, status) for 100% of selected tasks
- **SC-003**: Users can dismiss the detail card and return to the task list within 0.3 seconds of the dismiss action
- **SC-004**: Detail card displays the correct task information matching the selected task card in 100% of cases
- **SC-005**: Detail card updates distance and travel time in real-time when location changes (within 30 seconds of significant location change, matching home task list behavior)

## Assumptions

- Detail card is presented as a modal sheet that slides up from the bottom of the screen
- User can dismiss the detail card via swipe down gesture or close button
- Detail card shows the same information as the task card but in a larger, more detailed format
- Task data comes from the same source as the home task list (DailyPlannerWorker)
- Real-time distance updates work the same way as in the home task list (inherits location service integration)
- Only one detail card can be open at a time
- Detail card presentation does not affect the underlying task list state
- Modal sheet follows iOS standard presentation patterns (slides up from bottom, can be dismissed by swipe down)
