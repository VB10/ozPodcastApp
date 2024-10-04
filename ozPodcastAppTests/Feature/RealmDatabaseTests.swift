//
//  RealmDatabaseTests.swift
//  ozPodcastAppTests
//
//  Created by vb10 on 6.09.2024.
//

import RealmSwift
import XCTest

@testable import ozPodcastApp

class TestObject: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""

    var idValue: String {
        return id.stringValue
    }
}

final class RealmDatabaseTests: XCTestCase {
    var realmDatabase: LocalDatabaseProtocol!

    override func setUp() {
        super.setUp()
        realmDatabase = RealmDatabase(
            inMemoryIdentfier: "TestableRealm",
            objects: [TestObject.self]
        )
    }

    func testAddItem() {
        let testObject = TestObject()
        testObject.name = "vb"

        realmDatabase.add(model: testObject)

        let items = realmDatabase.items<TestObject>() as [TestObject]

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.name, "vb")
    }

    func testDeleteItem() {
        let testObject = TestObject()
        testObject.name = "vb"

        realmDatabase.add(model: testObject)

        var items = realmDatabase.items<TestObject>() as [TestObject]

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.name, "vb")

        realmDatabase.delete(model: testObject)

        items = realmDatabase.items<TestObject>() as [TestObject]

        XCTAssertEqual(items.count, 0)
    }

    func testClearAll() {
        let testObject = TestObject()
        testObject.name = "vb"

        realmDatabase.add(model: testObject)

        var items = realmDatabase.items<TestObject>() as [TestObject]

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.name, "vb")

        realmDatabase.clearAll(model: TestObject.self)

        items = realmDatabase.items<TestObject>() as [TestObject]

        XCTAssertEqual(items.count, 0)
    }

    func testDeleteFromId() {
        let testObject = TestObject()
        testObject.name = "vb"

        realmDatabase.add(model: testObject)

        var items = realmDatabase.items<TestObject>() as [TestObject]

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.name, "vb")

        realmDatabase.deleteFromId(model: TestObject.self, id: items.first!.idValue)

        items = realmDatabase.items<TestObject>() as [TestObject]

        XCTAssertEqual(items.count, 0)
    }
}
