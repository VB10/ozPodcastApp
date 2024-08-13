//
//  HomePresenter.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.08.2024.
//
//

import Foundation

class HomePresenter: ViewToPresenterHomeProtocol {
    // MARK: Properties

    var view: PresenterToViewHomeProtocol?
    var interactor: PresenterToInteractorHomeProtocol?
    var router: PresenterToRouterHomeProtocol?

    func onLikPressed() {
        interactor?.saveLikeCountInDatabase()
    }
}

extension HomePresenter: InteractorToPresenterHomeProtocol {
    func showSuccsessMessage(message: String) {
        view?.showDialogMessage(message: message)
    }
}
