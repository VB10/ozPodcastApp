//
//  BaseView.swift
//  ozPodcastApp
//
//  Created by vb10 on 15.08.2024.
//

import UIKit

class BaseView<T: UIViewController>: UIView, MainThreadRunner {
    var controller: T

    init(_ controller: T) {
        self.controller = controller
        super.init(frame: .zero)
        //        backgroundColor = Theme.defaultTheme.themeColor.backgroundColor
        setupView()
    }

    static var appTheme: AppTheme {
        ThemeManager.deafultTheme
    }

    var currentTheme: AppTheme {
        ThemeManager.deafultTheme
    }

    func setupView() {}
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
