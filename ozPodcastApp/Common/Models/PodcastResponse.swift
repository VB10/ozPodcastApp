//
//  PodcastResponse.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.03.2025.
//

import Foundation
import RealmSwift

struct PodcastResponse: Decodable, Equatable {
    let id: String?
    let title: String?
    let description: String?
    let thumbnail: String?
    let audioTime: String?
    var audioUrl: String?
    let createdAt: Date?
    let localPathUrl: String?

    lazy var audioTimeSeconds: Int = {
        let time = self.audioTime?.split(separator: ":").map { Int($0) ?? 0 }
        return (time?.first ?? 0) * 60 + (time?.last ?? 0)
    }()

    static func fromRealm(podcastRealm: PodcastResponseRealm) -> PodcastResponse {
        return .init(
            id: podcastRealm.podcastId,
            title: podcastRealm.title,
            description: podcastRealm.body,
            thumbnail: podcastRealm.thumbnail,
            audioTime: podcastRealm.audioTime,
            audioUrl: podcastRealm.audioUrl,
            createdAt: podcastRealm.createdAt,
            localPathUrl: podcastRealm.localPathUrl
        )
    }

    static let mock: PodcastResponse = .init(
        id: "65b54fe9aa734841b79a7667",
        title: "317 Şeref",
        description: "22222",
        thumbnail: "https://avatars.githubusercontent.com/u/17102578?v=4",
        audioTime: "27:49",
        audioUrl: "https://firebasestorage.googleapis.com/v0/b/vb-podcast.appspot.com/o/359697475-44100-1-cc3860e423034.mp4?alt=media&token=c7d4dcce-04ff-459a-9553-47e83ed6c7bb",
        createdAt: Date.now,
        localPathUrl: ""
    )

    var isFile: Bool {
        return self.audioUrl?.starts(with: "file:///") ?? false
    }

    static func == (lhs: PodcastResponse, rhs: PodcastResponse) -> Bool {
        return lhs.id == rhs.id
    }
}

final class PodcastResponseRealm: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var body: String = ""
    @Persisted var thumbnail: String = ""
    @Persisted var audioUrl: String = ""
    @Persisted var podcastId: String = ""
    @Persisted var audioTime: String = ""
    @Persisted var createdAt: Date = .now
    @Persisted var localPathUrl: String = ""

    override static func primaryKey() -> String? {
        return "podcast"
    }

    static func from(response: PodcastResponse, localPath: String) -> PodcastResponseRealm {
        let podcastRealm = PodcastResponseRealm()
        podcastRealm.title = response.title ?? ""
        podcastRealm.body = response.description ?? ""
        podcastRealm.thumbnail = response.thumbnail ?? ""
        podcastRealm.audioUrl = response.audioUrl ?? ""
        podcastRealm.podcastId = response.id ?? ""
        podcastRealm.audioTime = response.audioTime ?? ""
        podcastRealm.createdAt = response.createdAt ?? Date.now
        podcastRealm.localPathUrl = localPath
        return podcastRealm
    }
}
