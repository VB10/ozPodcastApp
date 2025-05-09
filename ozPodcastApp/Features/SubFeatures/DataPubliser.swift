//
//  DataPubliser.swift
//  ozPodcastApp
//
//  Created by vb10 on 4.10.2024.
//

import Combine
import Foundation

protocol DataPubliserProtocol {
    func updateCurrent(music: PodcastResponse)
    func removeCurrentMusic()
    func updateCurrentMusicTime(time: Double, percent: Float)
    var current: CurrentMusic? { get }
}

final class DataPublisher: DataPubliserProtocol {
    let musicPublishSubject = PassthroughSubject<CurrentMusic?, Never>()

    private var currentMusic: CurrentMusic?
    
    init(currentMusic: CurrentMusic? = nil) {
        self.currentMusic = currentMusic
    }
    
    var current: CurrentMusic? {
        currentMusic
    }

    func updateCurrent(music: PodcastResponse) {
        guard currentMusic?.music != music else { return }
        currentMusic = CurrentMusic(music: music, time: 0, percent: 0)
        musicPublishSubject.send(currentMusic)
    }

    func removeCurrentMusic() {
        currentMusic = nil
        musicPublishSubject.send(nil)
    }

    func updateCurrentMusicTime(time: Double, percent: Float) {
        guard let music = currentMusic else { return }
        currentMusic = music.copyWith(time: time, percent: percent)
        musicPublishSubject.send(currentMusic)
    }
}
