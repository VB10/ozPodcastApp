//
//  HomeDetailPresenter.swift
//  PodcastApp
//
//  Created by vb10 on 7.02.2024.
//
//

import Foundation

final class HomeDetailPresenter {
    // MARK: Properties

    private weak var view: PresenterToViewHomeDetailProtocol?
    private weak var interactor: PresenterToInteractorHomeDetailProtocol?
    private weak var router: PresenterToRouterHomeDetailProtocol?

    init(interactor: PresenterToInteractorHomeDetailProtocol, router: PresenterToRouterHomeDetailProtocol, view: PresenterToViewHomeDetailProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
}

extension HomeDetailPresenter: ViewToPresenterHomeDetailProtocol {
    func musicToLibrary() {
        Task {
            await interactor?.addToLibrary()
        }
    }

    func backButtonTapped() {
        router?.backToHome()
    }

    func openMusicRateSheet() {
        router?.openSpeedRateDialog()
    }

    func peekMusicPlayer(item: PeekMusicItems) {
        switch item {
        case .next:
            interactor?.nextSeconds()
        case .previous:
            interactor?.backSeconds()
        }
    }

    func startMusicPlayer() {
        interactor?.startMusicPlayer()
    }

    func pauseMusicPlayer() {
        interactor?.stopMusicPlayer()
    }

    func close() {
        interactor?.closeMusicPlayer()
    }
}

extension HomeDetailPresenter: InteractorToPresenterHomeDetailProtocol, MainThreadRunnerType {
    func initialLoad(podcast: PodcastResponse) {

        view?.updateUI(podcast: podcast)
        interactor?.checkCurrentPlay()
    }

    func addedLibraryItems(result: Bool, path: String?) {
        runOnMainSafety {
            guard let view = self.view else { return }
            view.showMessageLibraryAdded(result: result)
        }

        guard let path = path else { return }
        runOnMainSafety {
            guard let interactor = self.interactor else { return }

            interactor.addToDatabase(path: path)
        }
    }

    func updateTimerValue(currentTime: Double, percent: Float) {
        guard let view = view else { return }
        view.updateTimeView(time: currentTime)
        guard currentTime > 1 else {
            view.updateProgressView(percent: 0)
            return
        }
        view.updateProgressView(percent: percent)
    }
}
