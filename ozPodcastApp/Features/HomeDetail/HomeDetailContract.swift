//
//  HomeDetailContract.swift
//  PodcastApp
//
//  Created by vb10 on 7.02.2024.
//
//

import Foundation

// MARK: View Output (Presenter -> View)

protocol PresenterToViewHomeDetailProtocol: AnyObject {
    func updateTimeView(time: Double)
    func updateProgressView(percent: Float)
    func showMessageLibraryAdded(result: Bool)
    func updateUI(podcast: PodcastResponse)
}

// MARK: View Input (View -> Presenter)

protocol ViewToPresenterHomeDetailProtocol: AnyObject {
    func startMusicPlayer()
    func pauseMusicPlayer()
    func musicToLibrary()
    func peekMusicPlayer(item: PeekMusicItems)
    func openMusicRateSheet()
    func backButtonTapped()
    func close()
}

// MARK: Interactor Input (Presenter -> Interactor)

protocol PresenterToInteractorHomeDetailProtocol: AnyObject {
    var presenter: InteractorToPresenterHomeDetailProtocol? { get }
    init(podcast: PodcastResponse, presenter: InteractorToPresenterHomeDetailProtocol?, database: LocalDatabase)
    func stopMusicPlayer()
    func startMusicPlayer()
    func nextSeconds()
    func backSeconds()
    func addToLibrary() async

    func closeMusicPlayer()
    func checkCurrentPlay()

    func addToDatabase(path: String)
}

// MARK: Interactor Output (Interactor -> Presenter)

protocol InteractorToPresenterHomeDetailProtocol {
    func updateTimerValue(currentTime: Double, percent: Float)
    func addedLibraryItems(result: Bool, path: String?)
    func initialLoad(podcast: PodcastResponse)
}

// MARK: Router Input (Presenter -> Router)

protocol PresenterToRouterHomeDetailProtocol: AnyObject {
    func openSpeedRateDialog()
    func backToHome()
}



enum PeekMusicItems {
    case next
    case previous
}
