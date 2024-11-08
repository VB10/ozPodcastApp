//
//  HomeView.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.08.2024.
//
//

import SnapKit
import UIKit

final class HomeView: BaseView<HomeViewController> {
    private var presenter: ViewToPresenterHomeProtocol {
        controller.presenter
    }

    override func setupView() {
        super.setupView()
        setupLayout()
        setupConstraints()
    }

    /// sample method to setup layout
    private lazy var podcastTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocaleKeys.welcomeUser.localized(with: "Veli")
        label.font = ThemeManager.deafultTheme.fontTheme.titleBoldFont
        return label
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .black
        indicator.startAnimating()
        return indicator
    }()

    private func setupLayout() {
        addSubview(podcastTitleLabel)
        addSubview(loadingIndicator)
    }

    private func setupConstraints() {
        podcastTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
        loadingIndicator.snp.makeConstraints { make in
            make.top.equalTo(podcastTitleLabel.snp.bottom).offset(20)
            make.centerX.equalTo(podcastTitleLabel)
            make.bottom.equalToSuperview()
        }
    }

    private func changeColorIndactor() {
        runOnMain {
            self.loadingIndicator.color = .red
        }
    }
}

#Preview {
    HomeViewController()
}
