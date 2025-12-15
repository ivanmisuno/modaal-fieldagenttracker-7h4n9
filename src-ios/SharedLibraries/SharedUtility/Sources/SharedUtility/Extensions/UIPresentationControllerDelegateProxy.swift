// (c) Copyright PopAppFactory 2025

import Foundation
import UIKit

public class UIPresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
  let didDismissHandler: AnyActionHandler<Void>

  public init(didDismissHandler: AnyActionHandler<Void>) {
    self.didDismissHandler = didDismissHandler
  }

  // MARK: - UIAdaptivePresentationControllerDelegate

  public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    didDismissHandler.invoke(())
  }
}

