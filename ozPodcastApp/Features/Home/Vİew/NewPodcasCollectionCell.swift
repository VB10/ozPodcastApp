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

    private let appTheme: AppTheme = ThemeManager.deafultTheme

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 500) // Set your desired height here
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

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.image = .imagePodcaster
        return imageView
    }()

    private lazy var playButtonOverlay: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .playButton
        imageView.tintColor = .black
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = appTheme.fontTheme.titleFont
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = appTheme.fontTheme.titleFont
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.layer.masksToBounds = true
        contentView.addSubview(playButtonOverlay)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        playButtonOverlay.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(-10)
            make.right.equalTo(imageView.snp.right).offset(-10)
            make.height.width.equalTo(30)
        }

        imageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(10)
        }
    }

    func configure(with podcast: PodcastResponse) {
        guard let imageUrl = URL(string: podcast.thumbnail ?? "") else { return }
        imageView.kf.setImage(with: imageUrl)
        titleLabel.text = podcast.title
        descriptionLabel.text = podcast.description
    }
}

#Preview {
    NewPodcasCollectionCell(frame: .zero, podcast: PodcastResponse.mock)
}
