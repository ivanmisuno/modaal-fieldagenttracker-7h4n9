// (c) Copyright PopAppFactory 2024

import UIKit
import SwiftUI
import RIBs
import RxSwift
import RxCocoa
import SimpleTheming
import Theming

final class HomeTabViewController: UIHostingController<HomeTabView>, HomeTabPresentable, HomeTabViewControllable {

  private let themeProvider: ThemeProviding
  private let viewState: HomeTabViewState
  private let taskTappedSubject = PublishSubject<Task>()

  init(themeProvider: ThemeProviding) {
    self.themeProvider = themeProvider
    self.viewState = HomeTabViewState()

    let view = HomeTabView(
      themeProvider: themeProvider,
      viewState: viewState)
      .onTaskTapped(taskTappedSubject.asObserver())

    super.init(rootView: view)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - HomeTabPresentable
  
  var tasks: Binder<[Task]> {
    Binder(viewState) { state, tasks in
      state.tasks = tasks
    }
  }
  
  var taskTapped: Observable<Task> {
    taskTappedSubject.asObservable()
  }
}

final class HomeTabViewState: ObservableObject {
  @Published var tasks: [Task] = []
}

struct HomeTabView: View {
  private let themeProvider: ThemeProviding
  @ObservedObject private var viewState: HomeTabViewState
  private var taskTappedObserver: AnyObserver<Task>?

  init(themeProvider: ThemeProviding, viewState: HomeTabViewState) {
    self.themeProvider = themeProvider
    self._viewState = ObservedObject(wrappedValue: viewState)
  }

  var body: some View {
    NavigationView {
      ScrollView {
        if viewState.tasks.isEmpty {
          EmptyStateView(themeProvider: themeProvider)
        } else {
          LazyVStack(spacing: 20) {
            ForEach(viewState.tasks) { task in
              TaskCard(task: task, themeProvider: themeProvider)
                .onTaskTapped(taskTappedObserver)
            }
          }
          .padding(.horizontal, 20)
          .padding(.vertical, 16)
        }
      }
      .background(themeProvider.color(.backgroundPrimary))
      .navigationTitle(LocalizedStringKey(localizable: .splashLogoSubtitle))
      .navigationBarTitleDisplayMode(.large)
    }
  }
  
  func onTaskTapped(_ observer: AnyObserver<Task>) -> Self {
    var copy = self
    copy.taskTappedObserver = observer
    return copy
  }
}

// MARK: - TaskCard

private struct TaskCard: View {
  let task: Task
  let themeProvider: ThemeProviding
  var taskTappedObserver: AnyObserver<Task>?
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // Image
      AsyncImage(url: task.photoURL) { phase in
        switch phase {
        case .empty:
          ProgressView()
            .frame(height: 220)
        case .success(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 220)
            .clipped()
        case .failure:
          Image(systemName: "photo")
            .font(themeProvider.font(.largeTitle))
            .foregroundColor(themeProvider.color(.textSecondary))
            .frame(height: 220)
            .frame(maxWidth: .infinity)
            .background(themeProvider.color(.backgroundSecondary))
        @unknown default:
          EmptyView()
        }
      }
      
      VStack(alignment: .leading, spacing: 16) {
        // Venue name
        Text(task.venueName)
          .font(themeProvider.font(.title2))
          .foregroundColor(themeProvider.color(.textPrimary))
        
        // Address
        Text(task.address)
          .font(themeProvider.font(.bodyRegular))
          .foregroundColor(themeProvider.color(.textSecondary))
        
        // Opening hours
        Text(task.openingHours)
          .font(themeProvider.font(.bodyRegular))
          .foregroundColor(themeProvider.color(.textSecondary))
        
        // Distance and travel time
        if let distance = task.distanceFromCurrentLocation, let travelTime = task.estimatedTravelTime {
          HStack(spacing: 16) {
            HStack(spacing: 8) {
              Image(systemName: "location.fill")
              Text(formatDistance(distance))
                .font(themeProvider.font(.bodyMedium))
                .foregroundColor(themeProvider.color(.textPrimary))
            }
            
            HStack(spacing: 8) {
              Image(systemName: "clock.fill")
              Text(formatTravelTime(travelTime))
                .font(themeProvider.font(.bodyMedium))
                .foregroundColor(themeProvider.color(.textPrimary))
            }
          }
        } else {
          Text(localizable: .distanceUnavailable)
            .font(themeProvider.font(.bodyRegular))
            .foregroundColor(themeProvider.color(.textSecondary))
        }
        
        // Planned visit time
        Text(formatVisitTime(task.plannedVisitTime))
          .font(themeProvider.font(.bodyRegular))
          .foregroundColor(themeProvider.color(.textSecondary))
        
        // Status badge
        StatusBadge(status: task.status, themeProvider: themeProvider)
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 20)
    }
    .background(themeProvider.color(.backgroundSecondary))
    .cornerRadius(16)
    .onTapGesture {
      taskTappedObserver?.onNext(task)
    }
  }
  
  func onTaskTapped(_ observer: AnyObserver<Task>?) -> Self {
    var copy = self
    copy.taskTappedObserver = observer
    return copy
  }
  
  private func formatVisitTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return "Planned: \(formatter.string(from: date))"
  }
  
  private func formatDistance(_ distance: Double) -> String {
    if distance < 1000 {
      return String(format: "%.0f m", distance)
    } else {
      return String(format: "%.1f km", distance / 1000)
    }
  }
  
  private func formatTravelTime(_ timeInterval: TimeInterval) -> String {
    let minutes = Int(timeInterval / 60)
    if minutes < 1 {
      return "< 1 min"
    } else if minutes == 1 {
      return "1 min"
    } else {
      return "\(minutes) min"
    }
  }
}

// MARK: - StatusBadge

struct StatusBadge: View {
  let status: TaskStatus
  let themeProvider: ThemeProviding
  
  var body: some View {
    Text(status.rawValue)
      .font(themeProvider.font(.caption1Emphasized))
      .foregroundColor(statusColor)
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .background(statusColor.opacity(0.1))
      .cornerRadius(4)
  }
  
  private var statusColor: Color {
    switch status {
    case .planned:
      return .blue
    case .enRoute:
      return .orange
    case .inProgress:
      return .purple
    case .done:
      return .green
    case .cancelled:
      return .red
    case .cantComplete:
      return .gray
    }
  }
}

// MARK: - EmptyStateView

private struct EmptyStateView: View {
  let themeProvider: ThemeProviding
  
  var body: some View {
    VStack(spacing: 16) {
      Image(systemName: "list.bullet.clipboard")
        .font(themeProvider.font(.largeTitle))
        .foregroundColor(themeProvider.color(.textSecondary))
      
      Text(localizable: .tasksEmptyStateMessage)
        .font(themeProvider.font(.bodyRegular))
        .foregroundColor(themeProvider.color(.textSecondary))
        .multilineTextAlignment(.center)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
