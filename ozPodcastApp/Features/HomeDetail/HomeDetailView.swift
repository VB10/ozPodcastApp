//
//  HomeDetailView.swift
//  PodcastApp
//
//  Created by vb10 on 7.02.2024.
//
//

import UIKit

class HomeDetailView: BaseView<HomeDetailViewController> {
    var delegate: ViewToPresenterHomeDetailProtocol?

    private var isMusicPlaying: Bool = false
    override func setupView() {
        super.setupView()
        setupLayout()
        setupConstraints()
    }

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.backButton, for: .normal)
        button.tintColor = ThemeManager.defaultTheme.themeColor.onPrimaryColor
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var podcastTitleLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeManager.defaultTheme.themeFont.sectionHeaderFontSize
        label.textColor = ThemeManager.defaultTheme.themeColor.onPrimaryColor
        label.text = "Now Playing"
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .imagePodcaster
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeManager.defaultTheme.themeFont.mainTitleFontSize
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeManager.defaultTheme.themeFont.subtitleFontSize
        return label
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.0
        progressView.progressTintColor = .primary
        return progressView
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(.playButton, for: .normal)
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var rewindButton: UIButton = {
        let button = UIButton()
        button.setImage(SystemIcons.backward.image, for: .normal)
        button.addTarget(self, action: #selector(rewindButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()

    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(SystemIcons.forward.image, for: .normal)
        button.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var speedButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.gray, for: .normal)
        button.setTitle("1X", for: .normal)
        button.addTarget(self, action: #selector(speedButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = ThemeManager.defaultTheme.themeFont.subtitleFontSize
        return label
    }()

    private lazy var downloadIcon: UIButton = {
        let button = UIButton()
        button.tintColor = .gray
        button.setImage(.cloudDownload, for: .normal)
        button.addTarget(self, action: #selector(downloadIconTapped), for: .touchUpInside)
        return button
    }()

    /// time label value
    var durationValue: String? {
        durationLabel.text
    }

    var progressValue: Float {
        progressView.progress
    }

    var detailTitle: String? {
        titleLabel.text
    }
}

// Actions
extension HomeDetailView {
    @objc func backButtonTapped() {
        delegate?.backButtonTapped()
    }

    @objc func playButtonTapped() {
        guard let delegate = delegate else { return }
        !isMusicPlaying ? delegate.startMusicPlayer() : delegate.pauseMusicPlayer()
        isMusicPlaying = !isMusicPlaying
        controlMusicPlayingButton()
    }

    @objc func rewindButtonTapped() {
        delegate?.peekMusicPlayer(item: .previous)
    }

    @objc func forwardButtonTapped() {
        delegate?.peekMusicPlayer(item: .next)
    }

    @objc func speedButtonTapped() {
        delegate?.openMusicRateSheet()
    }

    @objc func downloadIconTapped() {
        delegate?.musicToLibrary()
    }
}

extension HomeDetailView {
    func updateMusicPlayProgress(value: Float) {
        runOnMain {
            UIView.animate(withDuration: 1) {
                self.progressView.setProgress(value, animated: true)
            }
        }
    }

    func updateMusicTimeField(value: Double) {
        let timerValue = value.timeString()
        runOnMain {
            self.durationLabel.text = timerValue
        }
    }

    func updateUI(podcast: PodcastResponse?) {
        guard let podcast = podcast else { return }
        guard let imageUrl = URL(string: podcast.thumbnail ?? "") else { return }
        runOnMain {
            self.updateHeaderViewHeight()
            self.imageView.kf.setImage(with: imageUrl)
            self.titleLabel.text = podcast.title
            self.durationLabel.text = podcast.audioTime
            self.descriptionLabel.text = podcast.description
        }
    }
}

extension HomeDetailView {
    private func controlMusicPlayingButton() {
        if !isMusicPlaying {
            playButton.setImage(.playButton, for: .normal)
            return
        }
        playButton.setImage(.pauseButton, for: .normal)
    }

    private func setupLayout() {
        addSubview(backButton)
        addSubview(podcastTitleLabel)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(progressView)
        addSubview(playButton)
        addSubview(rewindButton)
        addSubview(forwardButton)
        addSubview(speedButton)
        addSubview(durationLabel)
        addSubview(downloadIcon)

        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        rewindButton.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
        forwardButton.setPreferredSymbolConfiguration(largeConfig, forImageIn: .normal)
    }

    func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.height.width.equalTo(25)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalToSuperview().offset(20)
        }

        podcastTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.centerX.equalToSuperview()
        }

        guard let imageViewHeight = imageView.image else { return }
        let aspectRatio = (imageViewHeight.size.height) / (imageViewHeight.size.width)

        imageView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(imageView.snp.width).multipliedBy(aspectRatio)
        }

        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(durationLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
        }

        progressView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }

        playButton.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(20)
            make.height.width.equalTo(80)
            make.centerX.equalToSuperview()
        }

        rewindButton.snp.makeConstraints { make in
            make.centerY.equalTo(playButton.snp.centerY)
            make.right.equalTo(playButton.snp.left).offset(-40)
        }

        forwardButton.snp.makeConstraints { make in
            make.centerY.equalTo(playButton.snp.centerY)
            make.left.equalTo(playButton.snp.right).offset(30)
        }

        speedButton.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(80)
            make.height.width.equalTo(30)
        }

        downloadIcon.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.bottom).offset(30)
            make.trailing.equalToSuperview().offset(-80)
            make.height.width.equalTo(30)
        }
    }
}

//
#Preview {
    HomeDetailRouter.createModule(podcast: PodcastResponse.mock)
}
