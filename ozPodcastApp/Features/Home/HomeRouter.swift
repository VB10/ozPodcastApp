//
//  TestVbRouter.swift
//  PodcastApp
//
//  Created by vb10 on 1.02.2024.
//
//

import Foundation
import UIKit

final class HomeRouter: PresenterToRouterHomeProtocol {
    // MARK: Static methods

    static func createModule() -> UIViewController {
        let viewController = HomeViewController()
        let interactor = HomeInteractor()
        let router = HomeRouter(navigation: viewController)
        let presenter: ViewToPresenterHomeProtocol & InteractorToPresenterHomeProtocol = HomePresenter(
            interactor: interactor, router: router, view: viewController)

        viewController.presenter = presenter
        interactor.presenter = presenter

        return viewController
    }

    let navigation: NavigationView

    init(navigation: NavigationView) {
        self.navigation = navigation
    }

    func navigateToDetail() {
//        navigation.present(<#T##viewController: UIViewController##UIViewController#>)
    }
}
