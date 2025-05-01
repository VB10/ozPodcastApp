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
    
    // Cache these instances to ensure we always return the same one
    private lazy var networkManagerInstance: NetworkManager = {
        guard let instance = container.resolve(NetworkManager.self) else {
            os_log(.error, log: logger, "NetworkManager not found")
            fatalError("NetworkManager not found")
        }
        return instance
    }()
    
    private lazy var databaseInstance: RealmDatabase = {
        guard let instance = container.resolve(RealmDatabase.self) else {
            os_log(.error, log: logger, "RealmDatabase not found")
            fatalError("RealmDatabase not found")
        }
        return instance
    }()
    
    private lazy var dataPublisherInstance: DataPublisher = {
        guard let instance = container.resolve(DataPublisher.self) else {
            os_log(.error, log: logger, "DataPubliser not found")
            fatalError("DataPubliser not found")
        }
        return instance
    }()
    
    private init() {
        container = Container()
        logger = OSLog(subsystem: "com.vb.ozPodcastApp", category: "AppContainer")
        registerDependencies()
    }
    
    /// Print message to console pretty
    func logErrorMessageToConsole(_ message: String) {
        os_log(.error, log: logger, "Error: \(message)")
    }
        
    /// Network manager object
    var network: NetworkManager {
        return networkManagerInstance
    }
    
    /// Database manager object
    var database: RealmDatabase {
        return databaseInstance
    }
    
    /// DataPublisher
    var dataPublisher: DataPublisher {
        return dataPublisherInstance
    }
    
    /// Register for global object with this method
    func registerDependencies() {
        os_log(.info, log: logger, "Registering dependencies vb10")
        container.register(NetworkManager.self) { _ in NetworkManager(config: NetworkConfig()) }
        container.register(RealmDatabase.self) { _ in RealmDatabase() }
        container.register(DataPublisher.self) { _ in DataPublisher() }
    }
}
