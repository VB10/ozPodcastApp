//
//  OnBoardContract.swift
//  ozPodcastApp
//
//  Created by vb10 on 26.11.2024.
//
//

import Foundation

// MARK: View Output (Presenter -> View)

protocol PresenterToViewOnBoardProtocol: AnyObject {}

// MARK: View Input (View -> Presenter)

protocol ViewToPresenterOnBoardProtocol {
    func onStartListeningPressed()
}

// MARK: Interactor Input (Presenter -> Interactor)

protocol PresenterToInteractorOnBoardProtocol {
    var presenter: InteractorToPresenterOnBoardProtocol? { get set }
    func saveUserFirstTime() -> Bool
}

// MARK: Interactor Output (Interactor -> Presenter)

protocol InteractorToPresenterOnBoardProtocol {}

// MARK: Router Input (Presenter -> Router)

protocol PresenterToRouterOnBoardProtocol {
    func navigateToHome()
}
