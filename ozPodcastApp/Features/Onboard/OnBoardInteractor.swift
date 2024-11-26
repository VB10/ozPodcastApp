//
//  OnBoardInteractor.swift
//  ozPodcastApp
//
//  Created by vb10 on 26.11.2024.
//
//

import Foundation

final class OnBoardInteractor: PresenterToInteractorOnBoardProtocol {
    func saveUserFirstTime() -> Bool {
        return true
    }

    // MARK: Properties

    var presenter: InteractorToPresenterOnBoardProtocol?
}
