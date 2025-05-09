//
//  OnBoardContract.swift
//  ozPodcastApp
//
//  Created by vb10 on 29.11.2024.
//
//

import Foundation

// MARK: View Output (Presenter -> View)

protocol PresenterToViewOnBoardProtocol: AnyObject {}

// MARK: View Input (View -> Presenter)

protocol ViewToPresenterOnBoardProtocol: AnyObject {
    func didTapOnBoardButton()
}

// MARK: Interactor Input (Presenter -> Interactor)

protocol PresenterToInteractorOnBoardProtocol {
    var presenter: InteractorToPresenterOnBoardProtocol? { get set }
    func saveFirstLaunch() -> Bool
}

// MARK: Interactor Output (Interactor -> Presenter)

protocol InteractorToPresenterOnBoardProtocol {}

// MARK: Router Input (Presenter -> Router)

protocol PresenterToRouterOnBoardProtocol {
    func navigateToMainScreen()
}
