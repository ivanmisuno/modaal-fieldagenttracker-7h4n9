# Field Agent Tracker

## Project Overview

**Original Request**: I want to build a progress-tracker app for field agents / merchants to track their day to day work. The agents use the app to plan their route between shops, perform merchandise placement validation, and submit reports (upload photos).

## Project Identifiers

- **Project ID**: 01KCGR5RK2XH75SM0FKBCJSK3E
- **GCP Project ID**: modaal-fieldagenttracker-7h4n9
- **Project Name**: Field Agent Tracker
- **iOS App Name**: FieldAgentTracker
- **iOS Bundle ID**: com.example.FieldAgentTracker
- **Project Description**: Field agent progress tracker

## Project Purpose

This iOS application enables field agents and merchants to efficiently track their daily work activities. The app provides functionality for:

- **Route Planning**: Plan and optimize routes between multiple shop locations
- **Merchandise Validation**: Perform on-site validation of merchandise placement
- **Report Submission**: Submit field reports with photo uploads

The app is designed to streamline field operations, improve data collection accuracy, and enhance communication between field agents and management.

## Project Structure

The project follows a modular architecture with the following key components:

### iOS App Target (`App`)
- Located at `iOS/App/`
- Contains only the app entry point and bootstrapping code
- Initializes the Root RIB and handles app lifecycle events
- **Note**: This target should not be modified when implementing features

### Main Module (`FieldAgentTrackerMain`)
- Located at `iOS/Libraries/FieldAgentTrackerMain/`
- Contains all app-specific RIBs, Workers, and Models
- Initial structure includes:
  - **Root RIB**: Top-level RIB that bootstraps the app
  - **Splash RIB**: Initial loading/splash screen
  - **Main RIB**: Home screen (currently empty, ready for feature implementation)

### Feature Development
- New features are implemented as RIBs under `iOS/Libraries/FieldAgentTrackerMain/Sources/FieldAgentTrackerMain/RIBs/`
- Features can be added to the Main RIB's view or organized in a TabBar container
- All business logic, data models, and UI components live within the Main module

### Specifications
- Feature specifications are stored in `spec/` directory
- Each feature has its own numbered directory (e.g., `spec/feature-001/`)
- Specifications include: `spec.md`, `plan.md`, and implementation artifacts

## Next Step

You can now proceed to the **Specify** phase of the Spec-Driven Development cycle. 

To create your first feature specification, describe the feature you want to implement. For example:
- "I want to add a route planning screen where agents can see a list of shops and plan their daily route"
- "I want to create a merchandise validation form where agents can check placement and take photos"
- "I want to implement a report submission screen with photo upload functionality"

The system will guide you through creating a detailed specification, technical plan, and implementation tasks for your first feature.
