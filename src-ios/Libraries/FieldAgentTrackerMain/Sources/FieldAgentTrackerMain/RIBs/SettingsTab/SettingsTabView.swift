// (c) Copyright PopAppFactory 2024

import UIKit
import SwiftUI
import RIBs
import SimpleTheming
import Theming

final class SettingsTabViewController: UIHostingController<SettingsTabView>, SettingsTabPresentable, SettingsTabViewControllable {

  private let themeProvider: ThemeProviding
  private let viewState: SettingsTabViewState

  init(themeProvider: ThemeProviding) {
    self.themeProvider = themeProvider
    self.viewState = SettingsTabViewState()

    let view = SettingsTabView(
      themeProvider: themeProvider,
      viewState: viewState)

    super.init(rootView: view)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class SettingsTabViewState: ObservableObject {
  // No @Published properties needed for placeholder
}

struct SettingsTabView: View {
  private let themeProvider: ThemeProviding
  @ObservedObject private var viewState: SettingsTabViewState

  init(themeProvider: ThemeProviding, viewState: SettingsTabViewState) {
    self.themeProvider = themeProvider
    self._viewState = ObservedObject(wrappedValue: viewState)
  }

  var body: some View {
    NavigationView {
      ZStack {
        themeProvider.color(.backgroundPrimary)
          .ignoresSafeArea()
        
        VStack(spacing: 20) {
          Image(systemName: "gearshape")
            .font(themeProvider.font(.largeTitle))
            .foregroundColor(themeProvider.color(.textSecondary))
          
          Text("Settings")
            .font(themeProvider.font(.title1))
            .foregroundColor(themeProvider.color(.textPrimary))
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}
