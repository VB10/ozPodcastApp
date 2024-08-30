//
//  TextFieldTheme.swift
//  ozPodcastApp
//
//  Created by vb10 on 21.08.2024.
//

import UIKit

struct TextFieldTheme {
    let font: UIFont
    let textColor: UIColor
    let placeHolderColor: UIColor
    let backgroundColor: UIColor
    let radius: CGFloat
}

extension TextFieldTheme {
    static var defaultTheme: TextFieldTheme {
        return TextFieldTheme(
            font: ThemeFont.defaultTheme.subTitleFont,
            textColor: ThemeColor.defaultTheme.textColor,
            placeHolderColor: ThemeColor.defaultTheme.secondaryColor,
            backgroundColor: ThemeColor.defaultTheme.primaryColor,
            radius: 10
        )
    }
}
