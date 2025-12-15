# Feature Specification: Home Task List

**Feature Name**: `001-home-task-list`
**Created**: 2025-01-27
**Status**: Draft
**Input**: User input:

```
The home screen should display a list of today tasks (shops to visit) on app start.
The list is ordered by the visiting order, with the completion status visible.

The task card should help the agent to navigate to the location:
- Name of the venue/shop
- Big photo of the front entrance
- The address of the venue
- Opening hours
- Travel distance and time.
- Planned visit time. Use mock data for the moment.
- Status of the job: Planned / En route / In progress / Done / Cancelled / Can't complete

Functional requirements:
- The distance to the shops should update in real time as the user's location changes;

Non-requirements:
- The visiting order, travel time - use mock data for now, we'll connect navigation later;
```

## User Scenarios & Testing _(mandatory)_

### User Story 1 - View Today's Task List on App Start (Priority: P1)

When a field agent opens the app, they immediately see a list of all tasks (shops to visit) scheduled for today. The list is ordered by the planned visiting order, making it easy to understand the day's workflow at a glance. Each task card displays essential information needed to navigate to and complete the visit.

**Why this priority**: This is the core value proposition - agents need to see their daily schedule immediately upon opening the app. Without this, agents cannot begin their workday effectively.

**Independent Test**: Can be fully tested by launching the app and verifying that today's tasks appear in the correct order with all required information visible. Delivers immediate visibility into the day's work schedule.

**Acceptance Scenarios**:

1. **Given** the app has just launched, **When** the home screen loads, **Then** the list of today's tasks is displayed, ordered by visiting order
2. **Given** there are tasks scheduled for today, **When** the home screen displays, **Then** each task card shows: venue name, photo, address, opening hours, travel distance/time, planned visit time, and status
3. **Given** there are no tasks scheduled for today, **When** the home screen loads, **Then** an appropriate empty state message is displayed
4. **Given** tasks have different completion statuses, **When** viewing the list, **Then** the status of each task is clearly visible and distinguishable

---

### User Story 2 - Real-Time Distance Updates (Priority: P2)

As the field agent moves throughout their day, the distance and estimated travel time to each shop automatically updates based on their current location. This ensures agents always have accurate information about how far they are from each location without needing to manually refresh.

**Why this priority**: Real-time distance updates help agents make informed decisions about route adjustments and time management. This improves efficiency and reduces the need for manual location checks.

**Independent Test**: Can be fully tested by moving the device (or simulating location changes) and observing that distance and travel time values update automatically without user interaction. Delivers dynamic, location-aware task information.

**Acceptance Scenarios**:

1. **Given** the app is displaying the task list, **When** the user's location changes, **Then** the distance and travel time for each task updates automatically
2. **Given** location services are enabled, **When** the user moves to a new location, **Then** distance updates occur within a reasonable time frame (within 30 seconds of significant location change)
3. **Given** location services are disabled or unavailable, **When** viewing the task list, **Then** distance information shows a fallback state (e.g., "Distance unavailable") without breaking the app

---

### Edge Cases

- What happens when there are no tasks scheduled for today?
  - System displays an empty state message indicating no tasks for today
- How does the system handle location permission denial?
  - System displays tasks with distance information showing "Distance unavailable" or similar fallback, and continues to function normally
- What happens when location services are temporarily unavailable (e.g., poor GPS signal)?
  - System continues to display the last known distance or shows "Updating..." state, and resumes updates when location becomes available
- How does the system handle tasks with missing data (e.g., no photo, no address)?
  - System displays available information and uses placeholder content (e.g., placeholder image, "Address not available") for missing fields
- What happens when the app is backgrounded and then reopened?
  - System refreshes the task list and updates distances based on current location
- How does the system handle rapid location changes?
  - System throttles updates to prevent excessive recalculations while maintaining reasonable accuracy
- What happens when a task's planned visit time has passed?
  - Task remains visible in the list with its status, allowing agents to see overdue tasks

## Requirements _(mandatory)_

### Functional Requirements

- **FR-001**: System MUST display a list of today's tasks (shops to visit) on the home screen when the app starts
- **FR-002**: System MUST order tasks by their planned visiting order
- **FR-003**: System MUST display completion status for each task in the list
- **FR-004**: System MUST display the following information for each task card:
  - Venue/shop name
  - Photo of the front entrance
  - Venue address
  - Opening hours
  - Travel distance from current location
  - Estimated travel time from current location
  - Planned visit time
  - Task status (Planned / En route / In progress / Done / Cancelled / Can't complete)
- **FR-005**: System MUST update travel distance and time in real-time as the user's location changes
- **FR-006**: System MUST use mock data for visiting order and travel time calculations
- **FR-007**: System MUST use mock data for planned visit times
- **FR-008**: System MUST handle cases where no tasks exist for today by displaying an appropriate empty state
- **FR-009**: System MUST continue to function normally when location services are unavailable, showing appropriate fallback states for distance information
- **FR-010**: System MUST persist and display task list data across app restarts for the current day

### Key Entities _(include if feature involves data)_

- **Task**: Represents a shop visit scheduled for today. Key attributes: venue name, address, opening hours, planned visit time, status, visiting order position, front entrance photo. Relationships: belongs to today's schedule, has a status, has a planned visiting order.
- **Location**: Represents a geographic point. Key attributes: latitude, longitude, address. Relationships: associated with tasks (venue location), associated with user (current location for distance calculations).

## Success Criteria _(mandatory)_

### Measurable Outcomes

- **SC-001**: Users can view their complete list of today's tasks within 2 seconds of app launch
- **SC-002**: Task list displays all required information (name, photo, address, opening hours, distance, time, planned visit time, status) for 100% of visible tasks
- **SC-003**: Distance and travel time updates occur within 30 seconds of significant user location changes (movement > 100 meters)
- **SC-004**: System maintains 99% uptime for displaying task list, even when location services are unavailable
- **SC-005**: Users can distinguish task statuses (Planned / En route / In progress / Done / Cancelled / Can't complete) with 100% visual clarity
- **SC-006**: Task list correctly displays tasks in visiting order as specified by mock data in 100% of cases

## Assumptions

- Tasks are pre-assigned and available for the current day
- Mock data includes realistic shop information (names, addresses, photos, opening hours)
- Mock data includes a visiting order that determines task sequence
- Location services are available on the device (with graceful degradation when unavailable)
- User has granted location permissions (with fallback behavior when denied)
- Task statuses are managed by the system (not user-editable in this feature)
- Photos are available for all tasks (with placeholder handling for missing images)
- Opening hours are displayed in a readable format (e.g., "9:00 AM - 5:00 PM")
- Distance calculations use standard geographic distance formulas
- Travel time estimates are based on distance and average travel speed (mock data)
