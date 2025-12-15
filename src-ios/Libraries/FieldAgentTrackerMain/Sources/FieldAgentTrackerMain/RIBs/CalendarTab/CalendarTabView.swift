// (c) Copyright PopAppFactory 2024

import UIKit
import SwiftUI
import RIBs
import SimpleTheming
import Theming

final class CalendarTabViewController: UIHostingController<CalendarTabView>, CalendarTabPresentable, CalendarTabViewControllable {

  private let themeProvider: ThemeProviding
  private let viewState: CalendarTabViewState

  init(themeProvider: ThemeProviding) {
    self.themeProvider = themeProvider
    self.viewState = CalendarTabViewState()

    let view = CalendarTabView(
      themeProvider: themeProvider,
      viewState: viewState)

    super.init(rootView: view)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class CalendarTabViewState: ObservableObject {
  // No @Published properties needed for placeholder
}

struct CalendarTabView: View {
  private let themeProvider: ThemeProviding
  @ObservedObject private var viewState: CalendarTabViewState

  init(themeProvider: ThemeProviding, viewState: CalendarTabViewState) {
    self.themeProvider = themeProvider
    self._viewState = ObservedObject(wrappedValue: viewState)
  }

  var body: some View {
    NavigationView {
      ZStack {
        themeProvider.color(.backgroundPrimary)
          .ignoresSafeArea()
        
        VStack(spacing: 20) {
          Image(systemName: "calendar")
            .font(themeProvider.font(.largeTitle))
            .foregroundColor(themeProvider.color(.textSecondary))
          
          Text("Calendar")
            .font(themeProvider.font(.title1))
            .foregroundColor(themeProvider.color(.textPrimary))
        }
      }
      .navigationTitle("Calendar")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}
