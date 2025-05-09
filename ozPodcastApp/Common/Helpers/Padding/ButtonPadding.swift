//
//  ButtonPadding.swift
//  ozPodcastApp
//
//  Created by vb10 on 29.11.2024.
//
import UIKit

enum ButtonPadding {
    case small
    case medium
    case large

    var paddingAll: NSDirectionalEdgeInsets {
        switch self {
        case .small: return .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        case .medium: return .init(top: 12, leading: 12, bottom: 12, trailing: 12)
        case .large: return .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        }
    }
}
