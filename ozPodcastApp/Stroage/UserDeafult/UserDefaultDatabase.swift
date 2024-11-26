//
//  UserDefaultDatabase.swift
//  ozPodcastApp
//
//  Created by vb10 on 27.11.2024.
//
import Foundation

final class UserDefaultsCacheManager {
    static let shared = UserDefaultsCacheManager()
    
    private init() {}
    
    private let userDefaults: UserDefaults = .standard
    
    @UserDefaultsStorage(key: "isFirstLaunch", defaultValue: true)
    var isFirstLaunch: Bool
    
    @UserDefaultsStorage(key: "lastUpdateDate", defaultValue: nil)
    var lastUpdateDate: Date?
    
    // MARK: - Generic methods for storing and retrieving data

    func save<T>(_ value: T, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func get<T>(forKey key: String, defaultValue: T) -> T {
        return userDefaults.object(forKey: key) as? T ?? defaultValue
    }
    
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    func clearAll() {
        if let bundleID = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundleID)
        }
    }
}

extension UserDefaultsCacheManager {
    func saveObject<T: Encodable>(_ object: T, forKey key: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        save(data, forKey: key)
    }
    
    func getObject<T: Decodable>(forKey key: String) throws -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
