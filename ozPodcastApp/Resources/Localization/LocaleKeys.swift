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
        case description = "onboard_subTitle"
        case buttonListen = "button_listen"
    }
}

extension Localizable {
    /// Localized your key
    var localized: String {
        NSLocalizedString(rawValue, comment: "")
    }

    /// Localized your key
    /// - Parameter arguments: <#arguments
    /// - Returns: Value with params
    func localized(with arguments: CVarArg...) -> String {
        String(format: localized, arguments)
    }
}
