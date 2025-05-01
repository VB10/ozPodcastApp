//
//  NetworkManagerProtocol.swift
//  ozPodcastApp
//
//  Created by vb10 on 1.09.2024.
//

import Alamofire
import Foundation

protocol NetworkManagerProtocol {
    func send<T: Decodable>(
        path: NetworkPathProtocol,
        method: NetworkMethod,
        type: T.Type,
        body: Encodable?,
        parameter: Parameters?
    ) async -> Result<T, Error>
    
    func downloadFile(
        withURL urlString: String,
        destination: @escaping DownloadRequest.Destination
    ) async -> Result<String, Error>
}

extension NetworkManagerProtocol {
    func send<T: Decodable>(
        path: NetworkPathProtocol,
        method: NetworkMethod,
        type: T.Type,
        body: Encodable? = nil,
        parameter: Parameters? = nil
    ) async -> Result<T, Error> {
        return await send(path: path, method: method, type: type, body: body, parameter: parameter)
    }
}
