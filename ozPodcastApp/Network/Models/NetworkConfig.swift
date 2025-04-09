//
//  NetworkConfig.swift
//  ozPodcastApp
//
//  Created by vb10 on 1.09.2024.
//

import Foundation

struct NetworkConfig {
    let baseUrl: String

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    init() {
        self.baseUrl = "https://itunes.apple.com/us/rss/toppodcasts/limit=100/json"
    }
}
