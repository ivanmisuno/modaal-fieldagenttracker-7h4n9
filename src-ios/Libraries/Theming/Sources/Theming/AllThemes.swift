// (c) Copyright PopAppFactory 2023

import UIKit
import SimpleTheming

extension Theme: Themeable {
  public static let mainTheme = Theme(key: "mainTheme")

  public func themed() -> Themed {
    switch self {
    case .mainTheme:
      return MainTheme()
    default:
      fatalError("You are accessing undefined theme.")
    }
  }
}
