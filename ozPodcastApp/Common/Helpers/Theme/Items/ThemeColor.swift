//
//  ThemeColor.swift
//  ozPodcastApp
//
//  Created by vb10 on 21.08.2024.
//

import UIKit

struct ThemeColor {
    let primaryColor: UIColor
    let secondaryColor: UIColor
    let errorColor: UIColor
    let textColor: UIColor
}

extension ThemeColor {
    static var defaultTheme: ThemeColor {
        return ThemeColor(
            primaryColor: .primary,
            secondaryColor: .darkGray,
            errorColor: .red,
            textColor: .blue
        )
    }
}
