// (c) Copyright PopAppFactory 2024

import Foundation

enum TaskStatus: String, CaseIterable, Equatable {
  case planned = "Planned"
  case enRoute = "En route"
  case inProgress = "In progress"
  case done = "Done"
  case cancelled = "Cancelled"
  case cantComplete = "Can't complete"
}
