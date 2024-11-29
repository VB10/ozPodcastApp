//
//  OnBoardInteractor.swift
//  ozPodcastApp
//
//  Created by vb10 on 29.11.2024.
//  
//

import Foundation

final class OnBoardInteractor: PresenterToInteractorOnBoardProtocol {
    func saveFirstLaunch() -> Bool {
        /// TODO: cache it this data
        return true
    }
    

    // MARK: Properties
    var presenter: InteractorToPresenterOnBoardProtocol?
}
