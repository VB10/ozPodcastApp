//
//  ButtonTheme.swift
//  ozPodcastApp
//
//  Created by vb10 on 21.08.2024.
//

import UIKit

struct ButtonTheme {
    let font: UIFont
    let textColor: UIColor
    let backgroundColor: UIColor
    let maximumLine: Int
}

extension ButtonTheme {
    static var defaultTheme: ButtonTheme {
        return ButtonTheme(
            font: ThemeFont.defaultTheme.titleFont,
            textColor: ThemeColor.defaultTheme.primaryColor,
            backgroundColor: .forgottenPurple,
            maximumLine: 2
        )
    }
}
