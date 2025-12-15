// (c) Copyright PopAppFactory 2024

import UIKit
import SwiftUI
import RIBs
import RxSwift
import RxCocoa
import SimpleTheming
import Theming

final class TaskDetailsViewController: UIHostingController<TaskDetailsView>, TaskDetailsPresentable, TaskDetailsViewControllable {

  private let themeProvider: ThemeProviding
  private let viewState: TaskDetailsViewState
  private let closeSubject = PublishSubject<Void>()
  private let backSubject = PublishSubject<Void>()

  init(themeProvider: ThemeProviding) {
    self.themeProvider = themeProvider
    self.viewState = TaskDetailsViewState()

    let view = TaskDetailsView(
      themeProvider: themeProvider,
      viewState: viewState)
      .onClose(closeSubject.asObserver())

    super.init(rootView: view)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - TaskDetailsPresentable

  var task: Binder<Task> {
    Binder(viewState) { state, task in
      state.task = task
    }
  }

  var closeTapped: Observable<Void> {
    closeSubject.asObservable()
  }

  var backTapped: Observable<Void> {
    backSubject.asObservable()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if isBeingDismissed {
      backSubject.onNext(())
    }
  }
}

final class TaskDetailsViewState: ObservableObject {
  @Published var task: Task?
}

struct TaskDetailsView: View {
  private let themeProvider: ThemeProviding
  @ObservedObject private var viewState: TaskDetailsViewState
  private var closeObserver: AnyObserver<Void>?

  init(themeProvider: ThemeProviding, viewState: TaskDetailsViewState) {
    self.themeProvider = themeProvider
    self._viewState = ObservedObject(wrappedValue: viewState)
  }

  var body: some View {
    NavigationView {
      ZStack {
        // Background
        themeProvider.color(.backgroundPrimary)
          .ignoresSafeArea()
        
        ScrollView {
          VStack(spacing: 0) {
            if let task = viewState.task {
              // Hero Image Section
              GeometryReader { geometry in
                AsyncImage(url: task.photoURL) { phase in
                  Group {
                    switch phase {
                    case .empty:
                      ZStack {
                        themeProvider.color(.backgroundSecondary)
                        ProgressView()
                      }
                    case .success(let image):
                      image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                    case .failure:
                      ZStack {
                        themeProvider.color(.backgroundSecondary)
                        Image(systemName: "photo")
                          .font(themeProvider.font(.largeTitle))
                          .foregroundColor(themeProvider.color(.textSecondary))
                      }
                    @unknown default:
                      EmptyView()
                    }
                  }
                }
              }
              .frame(height: 300)
              .frame(maxWidth: .infinity)
              
              // Content Section
              VStack(alignment: .leading, spacing: 24) {
                // Venue Name
                Text(task.venueName)
                  .font(themeProvider.font(.title1))
                  .foregroundColor(themeProvider.color(.textPrimary))
                  .lineLimit(nil)
                  .fixedSize(horizontal: false, vertical: true)
                
                // Address
                HStack(alignment: .top, spacing: 8) {
                  Image(systemName: "mappin.circle.fill")
                    .font(themeProvider.font(.bodyRegular))
                    .foregroundColor(themeProvider.color(.textSecondary))
                    .frame(width: 20)
                  
                  Text(task.address)
                    .font(themeProvider.font(.bodyRegular))
                    .foregroundColor(themeProvider.color(.textSecondary))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                }
                
                // Opening Hours
                HStack(alignment: .top, spacing: 8) {
                  Image(systemName: "clock.fill")
                    .font(themeProvider.font(.bodyRegular))
                    .foregroundColor(themeProvider.color(.textSecondary))
                    .frame(width: 20)
                  
                  Text(task.openingHours)
                    .font(themeProvider.font(.bodyRegular))
                    .foregroundColor(themeProvider.color(.textSecondary))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                }
                
                // Distance and Travel Time
                if let distance = task.distanceFromCurrentLocation, let travelTime = task.estimatedTravelTime {
                  HStack(spacing: 24) {
                    // Distance
                    HStack(spacing: 8) {
                      Image(systemName: "location.fill")
                        .font(themeProvider.font(.bodyMedium))
                        .foregroundColor(themeProvider.color(.accentPrimary))
                      
                      Text(formatDistance(distance))
                        .font(themeProvider.font(.bodyMedium))
                        .foregroundColor(themeProvider.color(.textPrimary))
                    }
                    
                    // Travel Time
                    HStack(spacing: 8) {
                      Image(systemName: "clock.fill")
                        .font(themeProvider.font(.bodyMedium))
                        .foregroundColor(themeProvider.color(.accentPrimary))
                      
                      Text(formatTravelTime(travelTime))
                        .font(themeProvider.font(.bodyMedium))
                        .foregroundColor(themeProvider.color(.textPrimary))
                    }
                  }
                } else {
                  HStack(spacing: 8) {
                    Image(systemName: "location.slash.fill")
                      .font(themeProvider.font(.bodyRegular))
                      .foregroundColor(themeProvider.color(.textSecondary))
                    
                    Text(localizable: .distanceUnavailable)
                      .font(themeProvider.font(.bodyRegular))
                      .foregroundColor(themeProvider.color(.textSecondary))
                  }
                }
                
                Divider()
                  .background(themeProvider.color(.textSecondary).opacity(0.2))
                
                // Planned Visit Time
                HStack(alignment: .top, spacing: 8) {
                  Image(systemName: "calendar")
                    .font(themeProvider.font(.bodyRegular))
                    .foregroundColor(themeProvider.color(.textSecondary))
                    .frame(width: 20)
                  
                  VStack(alignment: .leading, spacing: 4) {
                    Text("Planned Visit Time")
                      .font(themeProvider.font(.subheadRegular))
                      .foregroundColor(themeProvider.color(.textSecondary))
                    
                    Text(formatVisitTime(task.plannedVisitTime))
                      .font(themeProvider.font(.bodyRegular))
                      .foregroundColor(themeProvider.color(.textPrimary))
                  }
                }
                
                // Status Badge
                StatusBadge(status: task.status, themeProvider: themeProvider)
              }
              .padding(.horizontal, 20)
              .padding(.top, 24)
              .padding(.bottom, 40)
            }
          }
        }
      }
      .navigationTitle(viewState.task?.venueName ?? "")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            closeObserver?.onNext(())
          }) {
            Image(systemName: "xmark.circle.fill")
              .font(themeProvider.font(.bodyRegular))
              .foregroundColor(themeProvider.color(.textSecondary))
          }
        }
      }
    }
  }

  func onClose(_ observer: AnyObserver<Void>) -> Self {
    var copy = self
    copy.closeObserver = observer
    return copy
  }

  private func formatVisitTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    return formatter.string(from: date)
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
