//
//  NetworkMethod.swift
//  ozPodcastApp
//
//  Created by vb10 on 1.09.2024.
//

import Alamofire
import Foundation

enum NetworkMethod {
    case GET
    case POST
    case PUT
    /// TODO: extension
    var alamofireMethod: HTTPMethod {
        switch self {
        case .GET:
            return .get
        case .POST:
            return .post
        case .PUT:
            return .put
        }
    }
}
