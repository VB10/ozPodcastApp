//
//  GeneralService.swift
//  ozPodcastApp
//
//  Created by vb10 on 14.03.2025.
//

import Foundation

protocol GeneralServiceProtocol: AnyObject {
    func podcast() async -> [PodcastResponse]?
}

final class GeneralServiceMock: GeneralServiceProtocol {
    func podcast() async -> [PodcastResponse]? {
        return [
            PodcastResponse(id: "15", title: "15", description: "", thumbnail: "", audioTime: "", audioUrl: "", createdAt: Date.now, localPathUrl: "")
        ]
    }
}

class GeneralService: GeneralServiceProtocol {
    private let networkManager: NetworkManager

    init() {
        networkManager = AppContainer.shared.network
    }

    func podcast() async -> [PodcastResponse]? {
        let result = await networkManager.send(path: .podcast, method: .GET, type: [PodcastResponse].self)

        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            AppContainer.shared.logErrorMessageToConsole(error.localizedDescription)
            return nil
        }
    }

    func search(textSearch: String) async -> [PodcastResponse]? {
        let result = await networkManager.send(path: .search, method: .GET, type: [PodcastResponse].self, paramater: ["q": textSearch])

        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            print(error)
            return nil
        }
    }
}
