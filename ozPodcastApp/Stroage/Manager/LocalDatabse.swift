//
//  LocalDatabse.swift
//  ozPodcastApp
//
//  Created by vb10 on 6.09.2024.
//

import RealmSwift

protocol LocalDatabaseProtocol {
    func add<T: Object>(model: T)
    func clearAll<T: Object>(model: T.Type)
    func items<T: Object>() -> [T]
    func delete<T: Object>(model: T)
    func deleteFromId<T: Object>(model: T.Type, id: String)

    func listenChanges<T: Object>(model: T.Type, result: @escaping (LocalDatabseUpdate, [Int]) -> Void)
}

enum LocalDatabseUpdate {
    case delete
    case inserte
    case modify
}
