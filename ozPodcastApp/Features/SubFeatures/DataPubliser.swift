//
//  DataPubliser.swift
//  ozPodcastApp
//
//  Created by vb10 on 4.10.2024.
//

import Combine
import Foundation

final class DataPublisher {
    let dataUpdated = PassthroughSubject<CurrentMusic?, Never>()

    private var currentMusic: CurrentMusic?
    var current: CurrentMusic? {
        return currentMusic
    }

    func updateCurrent(music: PodcastResponse) {
        guard currentMusic?.music != music else { return }
        currentMusic = CurrentMusic(music: music, time: 0, percent: 0)
        dataUpdated.send(currentMusic)
    }

    func removeCurrentMusic() {
        currentMusic = nil
        dataUpdated.send(nil)
    }

    func updateCurrentMusicTime(time: Double, percent: Float) {
        guard let music = currentMusic else { return }
        currentMusic = music.copyWith(time: time, percent: percent)
        dataUpdated.send(currentMusic)
    }
}
