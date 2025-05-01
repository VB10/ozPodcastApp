//
//  HomePresenter.swift
//  PodcastApp
//
//  Created by Beyza Karadeniz on 27.01.2024.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectPodcast(_ podcast: PodcastResponse)
    func didTapSearch()
}

final class HomePresenter: HomePresenterProtocol {
    private let interactor: HomeInteractorProtocol
    private let router: HomeRouterInput
    private weak var view: HomeViewInput?

    init(interactor: HomeInteractorProtocol,
         router: HomeRouterInput,
         view: HomeViewInput)
    {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

    func viewDidLoad() {
        guard let view = view else { return }
        Task { @MainActor in
            view.showLoading(true)
            let podcasts = await interactor.getPodcasts()
            view.updatePodcastsCollectionView(items: podcasts)
            view.showLoading(false)
        }
    }

    func didSelectPodcast(_ podcast: PodcastResponse) {
        router.navigateToPodcast(podcastResponse: podcast)
    }

    func didTapSearch() {
        router.navigateToSearch()
    }
}
