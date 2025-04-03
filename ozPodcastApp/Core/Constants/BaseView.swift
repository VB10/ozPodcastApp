//
//  BaseView.swift
//  ozPodcastApp
//
//  Created by vb10 on 15.08.2024.
//

import UIKit

class BaseView<T: UIViewController>: UIView, MainThreadRunnerType {
    var controller: T

    init(_ controller: T) {
        self.controller = controller
        super.init(frame: .zero)
        backgroundColor = .white
        setupView()
    }
    
    var appTheme: AppTheme {
        ThemeManager.deafultTheme
    }
    
    static var currentTheme: AppTheme {
        ThemeManager.deafultTheme
    }
    

    func setupView() {
        setupConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        return view
    }()

    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = appTheme.fontTheme.titleBoldFont
        return label
    }()

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    func setupConstraint() {
        addSubview(headerView)
        addSubview(mainView)
        addSubview(titleLabel)
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        mainView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(headerView.snp.bottom).offset(-10)
        }
    }

    /// Default header view height is 0.1
    func updateHeaderViewHeight(percent: Double = 0.1) {
        headerView.snp.remakeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(percent)
        }
    }
}


