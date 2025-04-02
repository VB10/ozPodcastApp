//
//  HomeView.swift
//  PodcastApp
//
//  Created by Beyza Karadeniz on 1.01.2024.
//

import Combine
import Foundation
import Lottie
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
        static let collectionItemsPerRow: CGFloat = 3
    }

    private var items: [PodcastResponse] = []
    private var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private var onGoingPodcast: PodcastResponse?
    private weak var presenter: HomePresenterProtocol?

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
        font: ThemeManager.deafultTheme.fontTheme.titleFont,
        color: ThemeManager.deafultTheme.colorTheme.primaryColor
    )
    private lazy var newPodcastsLabel: UILabel = createLabel(
        text: Constants.newPodcasts,
        font: ThemeManager.deafultTheme.fontTheme.subTitleFont,
        color: ThemeManager.deafultTheme.colorTheme.primaryColor
    )
    private lazy var collectionPodcastView: UICollectionView = createCollectionView()

    override func setupView() {
        super.setupView()
        setupSubviews()
        setupConstraints()
        setupBindings()
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
        showOrHiddenContuniueMusic(music: current)
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
            guard let self = self else { return }
            if isLoading {
                loadingLottie.play()
                loadingLottie.isHidden = false
            } else {
                loadingLottie.stop()
                loadingLottie.isHidden = true
            }
        }
    }

    func updatePodcastsCollectionView(items: [PodcastResponse]) {
        self.items = items
        runOnMainSafety {
            self.collectionPodcastView.reloadData()
        }
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
        collectionView.register(NewPodcasCollectionCell.self,
                                forCellWithReuseIdentifier: NewPodcasCollectionCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }
}

extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NewPodcasCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NewPodcasCollectionCell.reuseIdentifier, for: indexPath)
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        let sectionInsets = layout?.sectionInset ?? .zero
        let spacing = layout?.minimumInteritemSpacing ?? 0

        let totalSpacing = sectionInsets.left + sectionInsets.right +
            (spacing * (Layout.collectionItemsPerRow - 1))
        let availableWidth = collectionView.bounds.width - totalSpacing
        let widthPerItem = availableWidth / Layout.collectionItemsPerRow
        let heightPerItem = widthPerItem * 2

        return CGSize(width: widthPerItem, height: heightPerItem)
    }
}

extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectPodcast(items[indexPath.row])
    }
}

extension HomeView {
    func showOrHiddenContuniueMusic(music: CurrentMusic?) {
        runOnMain {
            let isHidden = music == nil
            self.onGoingView.isHidden = isHidden
            self.continueLabel.isHidden = isHidden

            self.continueLabel.snp.remakeConstraints { make in
                make.leading.trailing.equalTo(20)
                make.top.equalTo(self.searchButton.snp.bottom).offset(isHidden ? 10 : 10)
            }

            self.onGoingView.snp.remakeConstraints { make in
                make.top.equalTo(self.continueLabel.snp.bottom).offset(isHidden ? 10 : 10)
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(isHidden ? 0 : 70)
            }
        }
    }

    func setupConstraints() {
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }

        continueLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(20)
            make.top.equalTo(searchButton.snp.bottom).offset(10)
            make.height.equalTo(0)
        }
        onGoingView.snp.makeConstraints { make in
            make.top.equalTo(continueLabel.snp.bottom).offset(0)
            make.trailing.leading.equalToSuperview().inset(20)
            make.height.equalTo(0)
        }

        newPodcastsLabel.snp.makeConstraints { make in
            make.top.equalTo(onGoingView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }

        collectionPodcastView.snp.makeConstraints { make in
            make.top.equalTo(newPodcastsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }

        loadingLottie.snp.makeConstraints { make in
            make.top.equalTo(newPodcastsLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
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
