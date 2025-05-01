//
//  HomeView.swift
//  PodcastApp
//
//  Created by Beyza Karadeniz on 1.01.2024.
//

import Combine
import Foundation
import Lottie
import SnapKit
import UIKit

protocol HomeViewInput: AnyObject {
    func updatePodcastsCollectionView(items: [PodcastResponse])
    func showLoading(_ isLoading: Bool)
}

final class HomeView: BaseView<HomeViewController>, HomeViewInput {
    // MARK: - Properties

    private enum Layout {
        static let iconSize: CGFloat = 20
        static let defaultPadding: CGFloat = 20
        static let buttonHeight: CGFloat = 40
        static let ongoingViewHeight: CGFloat = 70
        static let smallVerticalSpacing: CGFloat = 10
    }

    private var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private var onGoingPodcast: PodcastResponse?
    private weak var presenter: HomePresenterProtocol?
    private var onGoingViewHeightConstraint: Constraint?
    private var collectionViewHelper: HomeCollectionViewHelper?

    // MARK: - UI Components

    private lazy var loadingLottie: LottieAnimationView = createLoadingLottie()

    private lazy var searchButton: UIButton = createSearchButton(
    )
    private lazy var onGoingView: OnGoingPodcastView = {
        let view = OnGoingPodcastView(frame: .zero, showProgressView: true)
        view.delegate = self
        return view
    }()

    private lazy var continueLabel: UILabel = createLabel(
        text: Constants.continueListening,
        font: ThemeManager.defaultTheme.fontTheme.titleFont,
        color: ThemeManager.defaultTheme.colorTheme.primaryColor
    )
    private lazy var newPodcastsLabel: UILabel = createLabel(
        text: Constants.newPodcasts,
        font: ThemeManager.defaultTheme.fontTheme.subTitleBoldFont,
        color: ThemeManager.defaultTheme.colorTheme.primaryColor
    )

    private lazy var collectionPodcastView: UICollectionView = createCollectionView()

    override func setupView() {
        super.setupView()
        setupSubviews()
        setupConstraints()
        setupBindings()
        collectionViewHelper = HomeCollectionViewHelper(collectionView: collectionPodcastView)
        collectionViewHelper?.delegate = self

        setTitle(LocaleKeys.Home.title.localized())
    }

    private func setupSubviews() {
        [searchButton, continueLabel, newPodcastsLabel,
         collectionPodcastView, loadingLottie, onGoingView].forEach(addSubview)
    }

    private func setupBindings() {
        AppContainer.shared.dataPublisher.dataUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] current in
                self?.handleCurrentMusicUpdate(current)
            }
            .store(in: &cancellables)
    }

    private func handleCurrentMusicUpdate(_ current: CurrentMusic?) {
        showOrHideContinueMusic(music: current)
        onGoingPodcast = current?.music
        if let music = current {
            onGoingView.updateUI(with: music)
        }
    }

    func setPresenter(_ presenter: HomePresenterProtocol) {
        self.presenter = presenter
    }

    func showLoading(_ isLoading: Bool) {
        runOnMainSafety { [weak self] in
            guard let self else { return }
            loadingLottie.isHidden = !isLoading
            if isLoading {
                loadingLottie.play()
            } else {
                loadingLottie.stop()
            }
        }
    }

    func updatePodcastsCollectionView(items: [PodcastResponse]) {
        collectionViewHelper?.updateItems(items)
    }
}

// MARK: - UI Creation Methods

private extension HomeView {
    func createLoadingLottie() -> LottieAnimationView {
        let animationView = LottieAnimationView(asset: Constants.homeLottie)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        return animationView
    }

    func createSearchButton() -> UIButton {
        var config = UIButton.Configuration.bordered()
        config.image = SystemIcons.search.image
        config.title = Constants.searchBarLabel
        config.baseForegroundColor = .black
        config.imagePlacement = .leading
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)

        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .left
        button.tintColor = .primary
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }

    func createLabel(text: String, font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        return label
    }

    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }
}

extension HomeView: HomeCollectionViewHelperDelegate {
    func didSelectItem(item: PodcastResponse) {
        presenter?.didSelectPodcast(item)
    }
}

extension HomeView {
    func showOrHideContinueMusic(music: CurrentMusic?) {
        runOnMain { [weak self] in
            guard let self else { return }
            let isHidden = music == nil
            self.onGoingView.isHidden = isHidden
            self.continueLabel.isHidden = isHidden

            self.onGoingViewHeightConstraint?.update(offset: isHidden ? 0 : Layout.ongoingViewHeight)
        }
    }

    private func setupConstraints() {
        setupSearchButtonConstraints()
        setupContinueListeningConstraints()
        setupPodcastListConstraints()
    }

    // MARK: - Constraint Setup Helpers

    private func setupSearchButtonConstraints() {
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Layout.defaultPadding)
            make.left.equalToSuperview().offset(Layout.defaultPadding)
            make.right.equalToSuperview().offset(-Layout.defaultPadding)
            make.height.equalTo(Layout.buttonHeight)
        }
    }

    private func setupContinueListeningConstraints() {
        continueLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Layout.defaultPadding)
            make.top.equalTo(searchButton.snp.bottom).offset(Layout.smallVerticalSpacing)
            make.height.equalTo(0)
        }

        onGoingView.snp.makeConstraints { make in
            make.top.equalTo(continueLabel.snp.bottom).offset(Layout.smallVerticalSpacing)
            make.trailing.leading.equalToSuperview().inset(Layout.defaultPadding)
            self.onGoingViewHeightConstraint = make.height.equalTo(0).constraint
        }
    }

    private func setupPodcastListConstraints() {
        newPodcastsLabel.snp.makeConstraints { make in
            make.top.equalTo(onGoingView.snp.bottom).offset(Layout.smallVerticalSpacing)
            make.leading.equalToSuperview().offset(Layout.defaultPadding)
            make.trailing.equalToSuperview().offset(-Layout.defaultPadding)
        }

        collectionPodcastView.snp.makeConstraints { make in
            make.top.equalTo(newPodcastsLabel.snp.bottom).offset(Layout.defaultPadding)
            make.leading.trailing.equalToSuperview().inset(Layout.defaultPadding)
            make.bottom.equalToSuperview().inset(Layout.defaultPadding)
        }

        loadingLottie.snp.makeConstraints { make in
            make.top.equalTo(newPodcastsLabel.snp.bottom).offset(Layout.defaultPadding)
            make.leading.trailing.equalToSuperview().inset(Layout.defaultPadding)
            make.bottom.equalToSuperview().inset(Layout.defaultPadding)
        }
    }
}

/// Actions
extension HomeView: OnGoingPodcastViewDelegate {
    @objc func searchButtonTapped() {
        presenter?.didTapSearch()
    }

    func onGoingPodcastViewDidTap() {
        guard let onGoingPodcast = onGoingPodcast else { return }
        presenter?.didSelectPodcast(onGoingPodcast)
    }
}

#Preview {
    HomeRouter.build()
}
