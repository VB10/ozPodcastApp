//
//  MusicManager.swift
//  PodcastApp
//
//  Created by vb10 on 25.01.2024.
//

import AVFoundation
import Combine
import Foundation

protocol MusicManagerProtocol {
    func listenMusicPoint(time: Double)
}

final class MusicManager: NSObject {
    init(delegate: MusicManagerProtocol) {
        self.delegate = delegate
    }

    let delegate: MusicManagerProtocol

    private func activateSession() {
        do {
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            try session.overrideOutputAudioPort(.speaker)
        } catch _ { }
    }

    private var player: AVPlayer?
    private var session = AVAudioSession.sharedInstance()
    private var cancellable: AnyCancellable?

    fileprivate func readFromLocally(_ url: String, _ url2: inout URL?) {
        // Get the path to the Documents directory
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentsPath.appendingPathComponent("\(url).mp4")
            if FileManager.default.fileExists(atPath: filePath.path) {
                print("File found: \(filePath.path)")
                url2 = filePath
            } else {
                print("File not found at \(filePath.path)")
            }
        }
    }

    func play(url: URL) {
        let playerItem = AVPlayerItem(url: url)

        if let player = player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            self.player = AVPlayer(playerItem: playerItem)
        }

        cancellable = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: playerItem).sink { [weak self] _ in
            guard let self = self else { return }
            self.stop()
        }
        guard let player = player else { return }
        player.play()
        checkCurrentPlay(url: url)
        
    }
    
    func checkCurrentPlay(url: URL) {
        //MARK: Refector this part
        guard let currentMusic = AppContainer.shared.dataPublisher.current else { return }
        guard let music = currentMusic.music else { return }
        guard url.absoluteString == music.audioUrl else { return }
        
        player?.seek(to: CMTime(seconds: currentMusic.time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }


    func `continue`() {
        guard let player = player else { return }
        player.play()
    }

    func pause() {
        guard let player = player else { return }
        player.pause()
    }

    func addObservers() {
        guard let player = player else { return }

        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            // Update player transport UI (e.g., slider, current time label)
            guard let self = self else { return }
            if player.currentItem?.status == .readyToPlay {
                self.delegate.listenMusicPoint(time: time.seconds)
            }
        }
    }

    func stop() {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
            guard let player = player else { return }
            player.pause()
        } catch _ { }
    }

    func seekMusicForward() {
        guard let player = player else { return }
        let currentTimeWithDelaySeconds = player.currentTime() + CMTime(seconds: 5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: currentTimeWithDelaySeconds)
    }

    func seekMusicBackward() {
        guard let player = player else { return }
        guard player.currentTime().seconds > 5 else { return }
        let currentTimeWithDelaySeconds = player.currentTime() - CMTime(seconds: 5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: currentTimeWithDelaySeconds)
    }
}
