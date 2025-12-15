//(c) Copyright PopAppFactory 2023

import Foundation

extension LocalizedStringResource {
  public func localized(_ locale: Locale) -> LocalizedStringResource {
    var copy = self
    copy.locale = locale
    return copy.localizedStringResource
  }
}
