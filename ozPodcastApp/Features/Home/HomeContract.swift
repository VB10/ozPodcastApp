//
//  HomeContract.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.08.2024.
//
//

import Foundation

// MARK: View Output (Presenter -> View)

protocol PresenterToViewHomeProtocol: AnyObject {
    func showMessage(message: String)
}

// MARK: View Input (View -> Presenter)

protocol ViewToPresenterHomeProtocol {
    func onLikePressed(index: Int)
}

// MARK: Interactor Input (Presenter -> Interactor)

protocol PresenterToInteractorHomeProtocol {
    var presenter: InteractorToPresenterHomeProtocol? { get set }

    func saveLikeIndexToDatabase(index: Int)
}

// MARK: Interactor Output (Interactor -> Presenter)

protocol InteractorToPresenterHomeProtocol {
    func showSuccessMessage()
}

// MARK: Router Input (Presenter -> Router)

protocol PresenterToRouterHomeProtocol {
    func navigateToDetail()
}
