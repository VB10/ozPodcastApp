//
//  OnBoardView.swift
//  ozPodcastApp
//
//  Created by vb10 on 29.11.2024.
//
//

import UIKit

final class OnBoardView: BaseView<OnBoardViewController> {
    weak var presenter: ViewToPresenterOnBoardProtocol?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: .imagePodcaster)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let profileTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocaleKeys.Onboard.title.localized
        label.font = currentTheme.fontTheme.titleBoldFont
        label.textColor = currentTheme.colorTheme.textColor
        label.textAlignment = .center
        return label
    }()
    
    private let profileSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocaleKeys.Onboard.description.localized
        label.numberOfLines = .zero
        label.font = currentTheme.fontTheme.subTitleFont
        label.textAlignment = .center
        return label
    }()
    
    private lazy var listingButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.filled()
        
        configuration.title = LocaleKeys.Onboard.buttonListen.localized
        configuration.baseBackgroundColor = appTheme.buttonTheme.backgroundColor
        configuration.contentInsets = ButtonPadding.medium.paddingAll
        configuration.background.cornerRadius = ProductRadius.medium.size

        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = self.appTheme.fontTheme.subTitleBoldFont
            return outgoing
        }
        
        button.addAction(listenAction, for: .touchUpInside)
        button.configuration = configuration
        return button
    }()
    
    lazy var listenAction: UIAction = UIAction { _ in
        self.presenter?.didTapOnBoardButton()
    }
    
    private lazy var columnStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileTitleLabel, profileSubtitleLabel, listingButton])
        stackView.axis = .vertical
        // TODO: Stackview space
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override func setupView() {
        super.setupView()
        setupLayout()
        setupConstraints()
    }

    private func setupLayout() {
        addSubview(profileImageView)
        addSubview(columnStackView)
    }

    func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(snp.width).multipliedBy(0.8)
            make.height.equalTo(snp.height).multipliedBy(0.4)
        }
        
        columnStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.right.equalTo(profileImageView)
        }
    }
}
