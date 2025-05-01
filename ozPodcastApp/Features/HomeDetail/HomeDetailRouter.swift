//
//  TestVbRouter.swift
//  PodcastApp
//
//  Created by vb10 on 1.02.2024.
//
//

import BottomSheet
import FittedSheets
import Foundation
import UIKit

final class HomeDetailRouter: PresenterToRouterHomeDetailProtocol {

    static func createModule(podcast: PodcastResponse) -> UIViewController {
        let viewController = HomeDetailViewController()
        let interactor = HomeDetailInteractor(podcast: podcast, database: AppContainers.localDatabase)
        let router = HomeDetailRouter(navigation: viewController)

        let presenter: ViewToPresenterHomeDetailProtocol & InteractorToPresenterHomeDetailProtocol = HomeDetailPresenter(
            interactor: interactor, router: router, view: viewController)

        viewController.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter

        return viewController
    }

    private let navigation: NavigationView

    private var presenter: ViewToPresenterHomeDetailProtocol?

    init(navigation: NavigationView) {
        self.navigation = navigation
    }

    let sheetTransitioningDelegate = SheetTransitioningDelegate()

    func openSpeedRateDialog() {
        let bottomShetViewController = SpeedRateSheetViewController()

        let sheetController = SheetViewController(controller: SpeedRateSheetViewController(),
                                                  sizes: [.fixed(200)])
        bottomShetViewController.selectionHandler = { [weak self] _ in
//            self?.presenter?.changeSpeedRate(rate: rate)
        }
        navigation.present(sheetController)
    }

    func backToHome() {
        navigation.dismiss()
    }
}
