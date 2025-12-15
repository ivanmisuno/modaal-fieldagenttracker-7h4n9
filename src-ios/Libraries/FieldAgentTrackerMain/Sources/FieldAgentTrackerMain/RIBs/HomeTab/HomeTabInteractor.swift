// (c) Copyright PopAppFactory 2024

import UIKit
import RIBs
import RxSwift
import RxCocoa

/// sourcery: CreateMock
protocol HomeTabRouting: ViewableRouting {
  func routeToTaskDetails(task: Task)
  func routeFromTaskDetails()
}

/// sourcery: CreateMock
protocol HomeTabListener: AnyObject {
}

/// sourcery: CreateMock
protocol HomeTabPresentable: Presentable {
  var tasks: Binder<[Task]> { get }
  var taskTapped: Observable<Task> { get }
}

final class HomeTabInteractor: PresentableInteractor<HomeTabPresentable>, HomeTabInteractable, TaskDetailsListener {

  weak var router: HomeTabRouting?
  weak var listener: HomeTabListener?
  
  private let dailyPlannerWorker: DailyPlannerWorking

  override init(presenter: HomeTabPresentable) {
    fatalError("Use init(dailyPlannerWorker:presenter:) instead")
  }
  
  init(dailyPlannerWorker: DailyPlannerWorking, presenter: HomeTabPresentable) {
    self.dailyPlannerWorker = dailyPlannerWorker
    super.init(presenter: presenter)
  }

  override func didBecomeActive() {
    super.didBecomeActive()
    
    // Start the worker
    dailyPlannerWorker.start(self)
    
    // Subscribe to tasks stream
    dailyPlannerWorker.tasks
      .observe(on: MainScheduler.instance)
      .bind(to: presenter.tasks)
      .disposeOnDeactivate(interactor: self)
    
    // Subscribe to task taps
    presenter.taskTapped
      .subscribe(onNext: { [router] task in
        router?.routeToTaskDetails(task: task)
      })
      .disposeOnDeactivate(interactor: self)
  }
  
  // MARK: - TaskDetailsListener
  
  func taskDetailsDidClose() {
    router?.routeFromTaskDetails()
  }

  override func willResignActive() {
    super.willResignActive()
  }
}
