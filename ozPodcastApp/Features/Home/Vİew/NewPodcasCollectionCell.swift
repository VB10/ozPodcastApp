//
//  NewPodcastViewController.swift
//  PodcastApp
//
//  Created by Beyza Karadeniz on 7.01.2024.
//

import Kingfisher
import SnapKit
import UIKit

final class NewPodcasCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: NewPodcasCollectionCell.self)

    // MARK: - Constants
    private enum Constants {
        static let imageViewCornerRadius: CGFloat = 20.0
        static let imageViewBorderWidth: CGFloat = 0.5
        static let playButtonSize: CGFloat = 30.0
        static let standardPadding: CGFloat = 10.0
        static let smallPadding: CGFloat = 6.0
        static let intrinsicHeight: CGFloat = 500.0 // Consider if this is truly necessary or handled by layout
        static let intrinsicWidth: CGFloat = 300.0 // Consider if this is truly necessary or handled by layout
    }

    private let appTheme: AppTheme = ThemeManager.defaultTheme

    // MARK: - Overrides
    override var intrinsicContentSize: CGSize {
        // This might be unnecessary if your collection view layout handles sizing dynamically.
        return CGSize(width: Constants.intrinsicWidth, height: Constants.intrinsicHeight)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    init(frame: CGRect, podcast: PodcastResponse) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        configure(with: podcast)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Elements
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        imageView.layer.borderWidth = Constants.imageViewBorderWidth
        imageView.layer.borderColor = appTheme.colorTheme.secondaryColor.cgColor // Use theme color
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        imageView.contentMode = .scaleAspectFill
        imageView.image = .imagePodcaster // Assuming this is a placeholder
        return imageView
    }()

    private lazy var playButtonOverlay: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .playButton // Assuming this is defined elsewhere
        imageView.tintColor = appTheme.colorTheme.secondaryColor // Use theme color
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = appTheme.fontTheme.subTitleBoldFont
        label.textColor = appTheme.colorTheme.secondaryColor // Use theme color
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = appTheme.fontTheme.contentFont
        label.textColor = appTheme.colorTheme.secondaryColor // Use theme color
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.layer.masksToBounds = true
        contentView.addSubview(playButtonOverlay)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        playButtonOverlay.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(-Constants.standardPadding)
            make.right.equalTo(imageView.snp.right).offset(-Constants.standardPadding)
            make.height.width.equalTo(Constants.playButtonSize)
        }

        imageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Constants.standardPadding)
            make.left.right.equalToSuperview().inset(Constants.standardPadding)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.smallPadding)
            make.left.right.equalToSuperview().inset(Constants.standardPadding)
        }
    }

    // MARK: - Configuration
    func configure(with podcast: PodcastResponse) {
        guard let imageUrl = URL(string: podcast.thumbnail ?? "") else { return }
        imageView.kf.setImage(with: imageUrl)
        titleLabel.text = podcast.title
        descriptionLabel.text = podcast.description
    }
}

#Preview {
    // Assuming PodcastResponse.mock provides a valid mock object
    NewPodcasCollectionCell(frame: .zero, podcast: PodcastResponse.mock)
}
