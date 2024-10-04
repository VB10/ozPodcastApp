//
//  AppContainer.swift
//  ozPodcastApp
//
//  Created by vb10 on 4.10.2024.
//

import Foundation
import os.log
import Swinject

final class AppContainer {
    static let shared = AppContainer()
    private let container: Container
    private let logger: OSLog
    
    private init() {
        container = Container()
        logger = OSLog(subsystem: "com.vb.ozPodcastApp", category: "AppContainer")
        registerDependencies()
    }
        
    /// Network manager object
    var network: NetworkManager {
        guard let instance = container.resolve(NetworkManager.self) else {
            os_log(.error, log: logger, "NetworkManager not found")
            fatalError("NetworkManager not found")
        }
        return instance
    }
    
    /// Database manager object
    var database: RealmDatabase {
        guard let instance = container.resolve(RealmDatabase.self) else {
            os_log(.error, log: logger, "RealmDatabase not found")
            fatalError("RealmDatabase not found")
        }
        return instance
    }
    
    /// DataPublisher
    var dataPublisher: DataPubliser {
        guard let instance = container.resolve(DataPubliser.self) else {
            os_log(.error, log: logger, "DataPubliser not found")
            fatalError("DataPubliser not found")
        }
        return instance
    }
    
    /// Register for global object with this method
    private func registerDependencies() {
        os_log(.info, log: logger, "Registering dependencies vb10")
        container.register(NetworkManager.self) { _ in NetworkManager(config: NetworkConfig(baseUrl: "https://api.github.com")) }
        
        container.register(RealmDatabase.self) { _ in RealmDatabase() }
        container.register(DataPubliser.self) { _ in DataPubliser() }
    }
}
