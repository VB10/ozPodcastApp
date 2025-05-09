//
//  SystemIcons.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.03.2025.
//

import UIKit

enum SystemIcons: String {
    case eyeNormal = "eye.fill"
    case eyeSlash = "eye.slash.fill"
    case backward = "gobackward.15"
    case forward = "goforward.15"
    case playCircle = "play.circle"
    case house
    case houseFill = "house.fill"
    case star
    case starFill = "star.fill"
    case person
    case personFill = "person.fill"
    case chevronFill = "chevron.right"
    case back = "chevron.left"
    case search = "magnifyingglass"
    case download = "arrow.down.circle"
    case close = "xmark"

    var image: UIImage {
        UIImage(systemName: rawValue)!
    }
}
