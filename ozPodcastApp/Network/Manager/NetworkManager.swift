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

    init(config: NetworkConfig, decoder: JSONDecoder = JSONDecoder()) {
        self.config = config
        self.decoder = decoder
        self.decoder.dateDecodingStrategy = .iso8601
    }

    /// Send your request
    /// - Parameters:
    ///   - path: Network Path
    ///   - method: HttpMethod
    ///   - type: Generic Decodable Type
    ///   - body: Nullable or Encodable
    ///   - parameter: Query parms. etc.
    /// - Returns: Result with sucses responre or error
    func send<T: Decodable>(
        path: NetworkPath,
        method: NetworkMethod,
        type: T.Type,
        body: Encodable? = nil,
        parameter: Parameters? = nil
    ) async -> Result<T, Error> {
        let url = "\(config.baseUrl)/\(path.rawValue)"
        let reqeust: DataRequest

        // TODO: Seperate client object
        if let body = body {
            reqeust = AF.request(
                url,
                method: method.alamofireMethod,
                parameters: body,
                encoder: JSONParameterEncoder.default
            )
        } else {
            reqeust = AF.request(
                url,
                method: method.alamofireMethod,
                parameters: parameter
            )
        }

        let response = await reqeust.validate()
            .serializingDecodable(T.self, decoder: decoder)
            .response

        guard let responseValue = response.value else {
            return .failure(response.error ?? NetworkError.unkown)
        }

        return .success(responseValue)
    }
}
