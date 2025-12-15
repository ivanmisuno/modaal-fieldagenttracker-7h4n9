//
//  SceneComponent.swift
//  FieldAgentTracker
//
//  Created by AI Assistant on 2025.
//

import RIBs
import FieldAgentTrackerMain

final class SceneComponent: Component<EmptyDependency>, RootDependency {
  init() {
    super.init(dependency: EmptyComponent())
  }
}
