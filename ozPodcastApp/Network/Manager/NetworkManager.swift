//
//  NetworkManager.swift
//  ozPodcastApp
//
//  Created by vb10 on 1.09.2024.
//

import Alamofire
import Foundation

final class NetworkManager: NetworkManagerProtocol {
    private let config: NetworkConfig
    private let decoder: JSONDecoder
    private let session: Session


    init(config: NetworkConfig, decoder: JSONDecoder = JSONDecoder()) {
        let eventMonitor: NetworkEventMonitor = NetworkEventMonitor();
        
        self.config = config
        self.decoder = decoder
        self.decoder.dateDecodingStrategy = .iso8601
        
        self.session = Session(
            eventMonitors: [eventMonitor]
        )
    }

    /// Send your request
    /// - Parameters:
    ///   - path: Network Path
    ///   - method: HttpMethod
    ///   - type: Generic Decodable Type
    ///   - body: Nullable or Encodable
    ///   - paramater: Query parms. etc.
    /// - Returns: Result with sucses responre or error
    func send<T: Decodable>(
        path: NetworkPathProtocol,
        method: NetworkMethod,
        type: T.Type,
        body: Encodable? = nil,
        paramater: Parameters? = nil
    ) async -> Result<T, Error> {
        let url = config.baseUrl + path.value
        let request: DataRequest

        // Create request based on whether body is provided
        if let body = body {
            request = session.request(
                url,
                method: method.alamofireMethod,
                parameters: body,
                encoder: JSONParameterEncoder.default
            )
        } else {
            request = session.request(
                url,
                method: method.alamofireMethod,
                parameters: paramater
            )
        }

        let response = await request.validate()
            .serializingDecodable(T.self, decoder: decoder)
            .response

        guard let responseValue = response.value else {
            return .failure(response.error ?? NetworkError.unkown)
        }

        return .success(responseValue)
    }
}
