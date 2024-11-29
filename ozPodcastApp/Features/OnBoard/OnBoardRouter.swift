//
//  TestVbRouter.swift
//  PodcastApp
//
//  Created by vb10 on 1.02.2024.
//
//

import Foundation
import UIKit

final class  OnBoardRouter: PresenterToRouterOnBoardProtocol {
    // MARK: Static methods

    static func createModule() -> UIViewController {
        let viewController = OnBoardViewController()
        let interactor = OnBoardInteractor()
        let router = OnBoardRouter(navigation: viewController)

        let presenter: ViewToPresenterOnBoardProtocol & InteractorToPresenterOnBoardProtocol = OnBoardPresenter(
            interactor: interactor, router: router, view: viewController)

        viewController.presenter = presenter
        interactor.presenter = presenter

        return viewController
    }

    let navigation: NavigationView

    init(navigation: NavigationView) {
        self.navigation = navigation
    }
}
