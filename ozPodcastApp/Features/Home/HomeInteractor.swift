//
//  HomeInteractor.swift
//  PodcastApp
//
//  Created by Beyza Karadeniz on 27.01.2024.
//

import Foundation

protocol HomeInteractorProtocol {
    func getPodcasts() async -> [PodcastResponse]
}

protocol HomeInteractorOutput: AnyObject {
    func podcastsFetched(_ podcasts: [PodcastResponse])
    func podcastsFetchFailed(_ error: Error)
}

final class HomeInteractor: BaseInteractor, HomeInteractorProtocol {
    weak var output: HomeInteractorOutput?
    internal let generalService: GeneralServiceProtocol
    
    init(generalService: GeneralServiceProtocol = GeneralService()) {
        self.generalService = generalService
    }
    
    func getPodcasts() async -> [PodcastResponse] {
        // Remove mock data in production
         return [PodcastResponse.mock]
        let response = await generalService.podcast()
        return response ?? []
    }
}
