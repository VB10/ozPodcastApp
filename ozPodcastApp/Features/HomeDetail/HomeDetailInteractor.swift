//
//  HomeDetailInteractor.swift
//  PodcastApp
//
//  Created by vb10 on 7.02.2024.
//
//

import AVFoundation
import Foundation
import RealmSwift

final class HomeDetailInteractor: PresenterToInteractorHomeDetailProtocol {
    private let database: LocalDatabaseProtocol
    private let networkManager = AppContainer.shared.network
    private var isPlayedFirstTime: Bool = true
    private var podcast: PodcastResponse

    private lazy var musicManager: MusicManager = {
        let manager = MusicManager(delegate: self)
        return manager
    }()

    private var dataPublisher: DataPubliserProtocol {
        AppContainer.shared.dataPublisher
    }

    var presenter: InteractorToPresenterHomeDetailProtocol? {
        didSet {
            presenter?.initialLoad(podcast: podcast)
        }
    }

    func addToDatabase(path: String) {
        let modelToAdd = PodcastResponseRealm.from(response: podcast, localPath: path)
        database.add(model: modelToAdd)
    }

    init(podcast: PodcastResponse, presenter: InteractorToPresenterHomeDetailProtocol? = nil, database: LocalDatabaseProtocol) {
        self.podcast = podcast
        self.presenter = presenter
        self.database = database
    }

    func checkCurrentPlay() {
        checkCurrentIsCont()
    }

    func addToLibrary() async {
        guard let id = podcast.id else { return }
        guard let audioUrl = podcast.audioUrl else { return }
        guard let destination = NetworkFile().destinationForDownloadedFile(name: id) else { return }
        var path: String?
        let downloadFile = await networkManager.downloadFile(
            withURL: audioUrl,
            destination: destination)
        switch downloadFile {
        case .success(let success):
            path = success

        case .failure(let failure):
            print(failure)
        }

        presenter?.addedLibraryItems(result: true, path: path)
    }

    func stopMusicPlayer() {
        musicManager.pause()
    }

    private func fetchMuiscUrlLocalOrRemote() -> URL? {
        guard let audioUrl = podcast.localPathUrl, !audioUrl.isEmpty else { return URL(string: podcast.audioUrl ?? "") }
        return MusicDocumentHelper(relativePath: audioUrl).documentURL
    }

    func startMusicPlayer() {
        guard let url = fetchMuiscUrlLocalOrRemote() else { return }

        if isPlayedFirstTime {
            musicManager.play(url: url)
            musicManager.addObservers()
            isPlayedFirstTime = false
            return
        }
        musicManager.continue()
    }

    func checkCurrentIsCont() {
        guard let currentMusic = dataPublisher.current else {
            updateCurrentMusicForGeneral()
            return
        }
        guard currentMusic.music == podcast && currentMusic.time > 0 else {
            return
        }

        presenter!.updateTimerValue(currentTime: currentMusic.time, percent: currentMusic.percent)
    }

    private func updateCurrentMusicForGeneral() {
        dataPublisher.updateCurrent(music: podcast)
    }

    func nextSeconds() {
        musicManager.seekMusicForward()
    }

    func backSeconds() {
        musicManager.seekMusicBackward()
    }

    func closeMusicPlayer() {
        musicManager.stop()
    }
}

extension HomeDetailInteractor: MusicManagerProtocol {
    func listenMusicPoint(time: Double) {
        var percent = Float(0)
        if time > 1 {
            percent = Float(time) / Float(podcast.audioTimeSeconds)
        }

        presenter!.updateTimerValue(currentTime: time, percent: percent)
        AppContainer.shared.dataPublisher.updateCurrentMusicTime(time: time, percent: percent)
    }
}
