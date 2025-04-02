//
//  HomeRouter.swift
//  PodcastApp
//
//  Created by Beyza Karadeniz on 27.01.2024.
//

import Foundation

protocol HomeRouterInput: AnyObject {
    func navigateToPodcast(podcastResponse: PodcastResponse)
    func navigateToSearch()
}

final class HomeRouter: HomeRouterInput {
    static func build() -> HomeViewController {
        let viewController = HomeViewController()
        let interactor = HomeInteractor()
        let router = HomeRouter(viewController: viewController)
        
        // Create presenter after view is initialized
        let presenter = HomePresenter(
            interactor: interactor,
            router: router,
            view: viewController.homeView
        )
        
        // Set presenter to both view controller and view
        viewController.updatePresenter(presenter: presenter)
        
        return viewController
    }

    let viewController: NavigationView

    init(viewController: NavigationView) {
        self.viewController = viewController
    }

    func navigateToPodcast(podcastResponse: PodcastResponse) {
        viewController.present(HomeDetailRouter.createModule(podcast: podcastResponse))
    }

    func navigateToSearch() {
        viewController.pushWithNavigationController(SearchRouter.createModule())
    }
}
