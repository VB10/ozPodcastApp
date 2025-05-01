//
//  NetworkPath.swift
//  ozPodcastApp
//
//  Created by vb10 on 1.09.2024.
//

import Foundation

enum NetworkPath: String, NetworkPathProtocol {
    case podcast = "podcast"
    case search = "search"

    var value: String {
        self.rawValue
    }
}

protocol NetworkPathProtocol {
    var value: String { get }
}
