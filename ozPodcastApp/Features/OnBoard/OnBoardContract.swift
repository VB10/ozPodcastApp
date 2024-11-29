//
//  OnBoardContract.swift
//  ozPodcastApp
//
//  Created by vb10 on 29.11.2024.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewOnBoardProtocol {
   
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterOnBoardProtocol {
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorOnBoardProtocol {
    
    var presenter: InteractorToPresenterOnBoardProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterOnBoardProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterOnBoardProtocol {
    
}
