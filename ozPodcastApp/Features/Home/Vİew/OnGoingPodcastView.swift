//
//  OnGoingView.swift
//  PodcastApp
//
//  Created by Beyza Karadeniz on 2.01.2024.
//
import SnapKit
import UIKit

protocol OnGoingPodcastViewDelegate: AnyObject {
    func onGoingPodcastViewDidTap()
}

final class OnGoingPodcastView: UIView {
    var delegate: OnGoingPodcastViewDelegate?
    init(frame: CGRect, showProgressView: Bool, podcast: PodcastResponse? = nil) {
        super.init(frame: frame)
        setupLayout(showProgressView: showProgressView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .imagePodcaster
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeManager.deafultTheme.fontTheme.subTitleBoldFont
        return label
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.5
        progressView.progressTintColor = .primary
        return progressView
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(SystemIcons.playCircle.image, for: .normal)
        button.setImage(.playButton, for: .normal)
        button.addAction(secureAction, for: .touchUpInside)
        return button
    }()

    private lazy var secureAction: UIAction = UIAction { _ in
        self.delegate?.onGoingPodcastViewDidTap()
    }

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeManager.deafultTheme.fontTheme.titleFont
        label.textColor = .gray
        return label
    }()

    func updateUI(with currentMusic: CurrentMusic) {
        guard let podcast = currentMusic.music else { return }
        guard let imageUrl = URL(string: podcast.thumbnail ?? "") else { return }
        titleLabel.text = podcast.title
        timeLabel.text = currentMusic.time.timeString()
        progressView.progress = currentMusic.percent
        imageView.kf.setImage(with: imageUrl)
    }

    private func setupLayout(showProgressView: Bool) {
        progressView.isHidden = !showProgressView

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(progressView)
        addSubview(playButton)
        addSubview(timeLabel)

        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.9

        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(8)
            make.top.equalTo(imageView)
        }

        if showProgressView {
            progressView.snp.makeConstraints { make in
                make.left.equalTo(titleLabel)
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
                make.right.equalTo(playButton.snp.left).offset(-8)
            }
            timeLabel.snp.makeConstraints { make in
                make.left.equalTo(titleLabel)
                make.top.equalTo(progressView.snp.bottom).offset(4)
                make.bottom.equalTo(imageView)
            }
        } else {
            timeLabel.snp.makeConstraints { make in
                make.left.equalTo(titleLabel)
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
            }
        }

        playButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
}

#Preview {
    OnGoingPodcastView(frame: .zero, showProgressView: false, podcast: PodcastResponse.mock)
}

struct User {
    var name: String
}
