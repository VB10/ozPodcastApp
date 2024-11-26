//
//  OnBoardView.swift
//  ozPodcastApp
//
//  Created by vb10 on 26.11.2024.
//
//

import UIKit

enum ButtonPadding {
    case small
    case medium
    case large

    var contentInsets: NSDirectionalEdgeInsets {
        switch self {
        case .small:
            return NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        case .medium:
            return NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        case .large:
            return NSDirectionalEdgeInsets(top: 15, leading: 30, bottom: 15, trailing: 30)
        }
    }
}

// https://www.figma.com/board/NbzPAOKLMEOpEoWu6jdjBK/Podcast-App?node-id=0-1&node-type=canvas&t=RsE5HNhUJAXHivyZ-0
final class OnBoardView: BaseView<OnBoardViewController> {
    override func setupView() {
        super.setupView()
        setupLayout()
        setupConstraints()
    }

    var presenter: PresenterToViewOnBoardProtocol?

    private static let profileTitle: String = "Podcaster"
    private static let profileSubTitle: String = "Discover your favorite podcast & listen to them anywhere!"
    private static let listingTitle: String = "Start Listing"

    /// sample method to setup layout
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: .imagePodcaster)
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private let profileTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocaleKeys.Onboard.title.localized
        label.font = appTheme.fontTheme.titleBoldFont
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let profileSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocaleKeys.Onboard.description.localized
        label.numberOfLines = .zero
        label.font = appTheme.fontTheme.subTitleFont
        return label
    }()

    private let listingButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.titleAlignment = .center
        configuration.title = LocaleKeys.Onboard.button.localized
        configuration.baseForegroundColor = appTheme.colorTheme.textColorFixed
        configuration.baseBackgroundColor = appTheme.buttonTheme.backgroundColor
        configuration.contentInsets = ButtonPadding.large.contentInsets
        configuration.background.cornerRadius = ProductRadius.small.rawValue
        let attributedString = NSAttributedString(
            string: listingTitle,
            attributes: [
                .font: appTheme.fontTheme.titleBoldFont,
                .foregroundColor: appTheme.colorTheme.textColorFixed
            ]
        )
        // Font options
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = appTheme.fontTheme.subTitleFont.bolded
        
            return outgoing
        }
        button.configuration = configuration

        return button
    }()

    private lazy var columnsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileTitleLabel, profileSubTitleLabel, listingButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private func setupLayout() {
        addSubview(profileImageView)
        addSubview(columnsStackView)
    }

    func setupConstraints() {
        backgroundColor = currentTheme.colorTheme.secondaryFixedColor
        profileImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(snp.width).multipliedBy(0.8)
            make.height.equalTo(snp.height).multipliedBy(0.4)
        }
        columnsStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.right.equalTo(profileImageView)
        }
    }
}
