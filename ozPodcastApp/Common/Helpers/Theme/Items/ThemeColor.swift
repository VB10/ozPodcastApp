//
//  ThemeColor.swift
//  ozPodcastApp
//
//  Created by vb10 on 21.08.2024.
//

import UIKit

struct ThemeColor {
    let primaryColor: UIColor
    let primaryFixedColor: UIColor
    let secondaryColor: UIColor
    let secondaryFixedColor: UIColor
    let errorColor: UIColor
    let textColor: UIColor
    let textColorFixed: UIColor
}

extension ThemeColor {
    static var defaultTheme: ThemeColor {
        return ThemeColor(
            primaryColor: .primary,
            primaryFixedColor: .forgottenPurple,
            secondaryColor: .darkGray,
            secondaryFixedColor: .cloudBreak,
            errorColor: .red,
            textColor: .blue,
            textColorFixed: .white
        )
    }
}
