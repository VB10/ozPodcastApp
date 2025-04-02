//
//  CurrentMusic.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.03.2025.
//

struct CurrentMusic: Equatable {
    static func == (lhs: CurrentMusic, rhs: CurrentMusic) -> Bool {
        return lhs.music == rhs.music
    }

    let music: PodcastResponse?
    let time: Double
    let percent: Float

    func copyWith(time: Double, percent: Float) -> CurrentMusic {
        return CurrentMusic(music: music, time: time, percent: percent)
    }
}
