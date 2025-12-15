// (c) Copyright PopAppFactory 2024

import UIKit
import SwiftUI
import RIBs
import SimpleTheming
import Theming

final class RoadPlannerTabViewController: UIHostingController<RoadPlannerTabView>, RoadPlannerTabPresentable, RoadPlannerTabViewControllable {

  private let themeProvider: ThemeProviding
  private let viewState: RoadPlannerTabViewState

  init(themeProvider: ThemeProviding) {
    self.themeProvider = themeProvider
    self.viewState = RoadPlannerTabViewState()

    let view = RoadPlannerTabView(
      themeProvider: themeProvider,
      viewState: viewState)

    super.init(rootView: view)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class RoadPlannerTabViewState: ObservableObject {
  // No @Published properties needed for placeholder
}

struct RoadPlannerTabView: View {
  private let themeProvider: ThemeProviding
  @ObservedObject private var viewState: RoadPlannerTabViewState

  init(themeProvider: ThemeProviding, viewState: RoadPlannerTabViewState) {
    self.themeProvider = themeProvider
    self._viewState = ObservedObject(wrappedValue: viewState)
  }

  var body: some View {
    NavigationView {
      ZStack {
        themeProvider.color(.backgroundPrimary)
          .ignoresSafeArea()
        
        VStack(spacing: 20) {
          Image(systemName: "map")
            .font(themeProvider.font(.largeTitle))
            .foregroundColor(themeProvider.color(.textSecondary))
          
          Text("Road Planner")
            .font(themeProvider.font(.title1))
            .foregroundColor(themeProvider.color(.textPrimary))
        }
      }
      .navigationTitle("Road Planner")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}
