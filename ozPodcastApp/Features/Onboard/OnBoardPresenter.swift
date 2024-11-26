//
//  OnBoardPresenter.swift
//  ozPodcastApp
//
//  Created by vb10 on 26.11.2024.
//
//

import Foundation

final class OnBoardPresenter: ViewToPresenterOnBoardProtocol {
    func onStartListeningPressed() {}

    // MARK: Properties

    private weak var view: PresenterToViewOnBoardProtocol?
    private let interactor: PresenterToInteractorOnBoardProtocol
    private let router: PresenterToRouterOnBoardProtocol

    init(interactor: PresenterToInteractorOnBoardProtocol, router: PresenterToRouterOnBoardProtocol, view: PresenterToViewOnBoardProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
}

extension OnBoardPresenter: InteractorToPresenterOnBoardProtocol {}
