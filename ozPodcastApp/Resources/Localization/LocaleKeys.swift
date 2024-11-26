//
//  LocaleKeys.swift
//  ozPodcastApp
//
//  Created by vb10 on 21.08.2024.
//

import Foundation

protocol Localizable: RawRepresentable where RawValue == String {
    var localized: String { get }
    func localized(with arguments: CVarArg...) -> String
}

enum LocaleKeys: String, Localizable {
    case welcomeMessage = "welcome"
    case welcomeUser = "welcome_user"

    enum Onboard: String, Localizable {
        case title = "onboard_title"
        case description = "onboard_sub_title"
        case button = "onboard_button"
    }
}

extension Localizable {
    /// Localized your key
    var localized: String {
        NSLocalizedString(rawValue, comment: "")
    }

    /// Localized with arguments
    func localized(with arguments: CVarArg...) -> String {
        String(format: localized, arguments: arguments)
    }
}
