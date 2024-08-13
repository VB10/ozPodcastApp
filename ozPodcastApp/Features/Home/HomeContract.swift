//
//  HomeContract.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.08.2024.
//
//

import Foundation

// MARK: View Output (Presenter -> View)

protocol PresenterToViewHomeProtocol {
    func showDialogMessage(message: String)
}

// MARK: View Input (View -> Presenter)

protocol ViewToPresenterHomeProtocol {
    var view: PresenterToViewHomeProtocol? { get set }
    var interactor: PresenterToInteractorHomeProtocol? { get set }
    var router: PresenterToRouterHomeProtocol? { get set }

    func onLikPressed()
}

// MARK: Interactor Input (Presenter -> Interactor)

protocol PresenterToInteractorHomeProtocol {
    var presenter: InteractorToPresenterHomeProtocol? { get set }

    func saveLikeCountInDatabase()
}

// MARK: Interactor Output (Interactor -> Presenter)

protocol InteractorToPresenterHomeProtocol {
    func showSuccsessMessage(message: String)
}

// MARK: Router Input (Presenter -> Router)

protocol PresenterToRouterHomeProtocol {}
