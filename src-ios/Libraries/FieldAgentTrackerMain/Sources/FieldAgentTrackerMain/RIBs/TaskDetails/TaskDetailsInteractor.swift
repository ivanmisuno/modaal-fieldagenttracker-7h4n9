// (c) Copyright PopAppFactory 2024

import UIKit
import RIBs
import RxSwift
import RxRelay
import RxCocoa

/// sourcery: CreateMock
protocol TaskDetailsRouting: ViewableRouting {
}

/// sourcery: CreateMock
protocol TaskDetailsListener: AnyObject {
  func taskDetailsDidClose()
}

/// sourcery: CreateMock
protocol TaskDetailsPresentable: Presentable {
  var task: Binder<Task> { get }
  var closeTapped: Observable<Void> { get }
  var backTapped: Observable<Void> { get }
}

final class TaskDetailsInteractor: PresentableInteractor<TaskDetailsPresentable>, TaskDetailsInteractable {

  weak var router: TaskDetailsRouting?
  weak var listener: TaskDetailsListener?
  
  private let task: Task

  init(task: Task, presenter: TaskDetailsPresentable) {
    self.task = task
    super.init(presenter: presenter)
  }

  override func didBecomeActive() {
    super.didBecomeActive()
    
    // Bind task to presenter
    presenter.task.onNext(task)
    
    // Subscribe to dismissal events
    Observable.merge([presenter.closeTapped, presenter.backTapped])
      .subscribe(onNext: { [listener] in
        listener?.taskDetailsDidClose()
      })
      .disposeOnDeactivate(interactor: self)
  }

  override func willResignActive() {
    super.willResignActive()
  }
}
