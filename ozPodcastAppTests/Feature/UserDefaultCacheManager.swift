//
//  UserDefaultCacheManager.swift
//  ozPodcastApp
//
//  Created by vb10 on 27.11.2024.
//

@testable import ozPodcastApp // Replace with your actual module name
import XCTest

final class CacheManagerTests: XCTestCase {
    var sut: UserDefaultsCacheManager!
    
    override func setUp() {
        super.setUp()
        sut = UserDefaultsCacheManager.shared
    }
    
    override func tearDown() {
        sut.clearAll()
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Basic Storage Tests
    
    func testSaveAndGetString() {
        // Given
        let testKey = "testString"
        let testValue = "Hello, Tests!"
        
        // When
        sut.save(testValue, forKey: testKey)
        let retrievedValue = sut.get(forKey: testKey, defaultValue: "")
        
        // Then
        XCTAssertEqual(retrievedValue, testValue)
    }
    
    func testSaveAndGetInteger() {
        // Given
        let testKey = "testInt"
        let testValue = 42
        
        // When
        sut.save(testValue, forKey: testKey)
        let retrievedValue = sut.get(forKey: testKey, defaultValue: 0)
        
        // Then
        XCTAssertEqual(retrievedValue, testValue)
    }
    
    func testGetDefaultValue() {
        // Given
        let testKey = "nonexistentKey"
        let defaultValue = "default"
        
        // When
        let retrievedValue = sut.get(forKey: testKey, defaultValue: defaultValue)
        
        // Then
        XCTAssertEqual(retrievedValue, defaultValue)
    }
    
    func testRemoveValue() {
        // Given
        let testKey = "testRemove"
        let testValue = "Test Value"
        sut.save(testValue, forKey: testKey)
        
        // When
        sut.remove(forKey: testKey)
        let retrievedValue = sut.get(forKey: testKey, defaultValue: "")
        
        // Then
        XCTAssertEqual(retrievedValue, "")
    }
    
    func testClearAll() {
        // Given
        sut.save("Test1", forKey: "key1")
        sut.save("Test2", forKey: "key2")
        
        // When
        sut.clearAll()
        
        // Then
        XCTAssertEqual(sut.get(forKey: "key1", defaultValue: ""), "")
        XCTAssertEqual(sut.get(forKey: "key2", defaultValue: ""), "")
    }
    
    // MARK: - Property Wrapper Tests
    
    func testIsFirstLaunchPropertyWrapper() {
        // Given
        let initialValue = sut.isFirstLaunch
        
        // When
        sut.isFirstLaunch = false
        
        // Then
        XCTAssertTrue(initialValue)
        XCTAssertFalse(sut.isFirstLaunch)
    }
    
    // MARK: - Codable Object Tests
    
    func testSaveAndGetCodableObject() {
        // Given
        struct TestUser: Codable, Equatable {
            let name: String
            let age: Int
        }
        
        let testUser = TestUser(name: "John", age: 30)
        let testKey = "testUser"
        
        // When
        XCTAssertNoThrow(try sut.saveObject(testUser, forKey: testKey))
        
        // Then
        do {
            let retrievedUser: TestUser? = try sut.getObject(forKey: testKey)
            XCTAssertEqual(retrievedUser, testUser)
        } catch {
            XCTFail("Failed to retrieve user: \(error)")
        }
    }
}
