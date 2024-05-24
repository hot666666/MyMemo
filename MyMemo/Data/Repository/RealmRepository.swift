//
//  RealmRepository.swift
//  MyMemo
//
//  Created by 최하식 on 5/23/24.
//

import Foundation
import RealmSwift

protocol RealmRepositoryProtocol {
    func fetchAll<T: Object>(_ type: T.Type) -> [T]
    func existingObject<T: Object>(_ type: T.Type, by id: String) -> T?
    func save<T: Object>(_ object: T)
    func update<T: Object>(_ object: T)
    func delete<T: Object>(_ object: T)
}

class RealmRepository: RealmRepositoryProtocol {
    private let realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    func fetchAll<T: Object>(_ type: T.Type) -> [T] {
        return Array(realm.objects(type))
    }
    
    func existingObject<T: Object>(_ type: T.Type, by id: String) -> T? {
        return realm.object(ofType: type, forPrimaryKey: id)
    }

    func save<T: Object>(_ object: T) {
        try? realm.write {
              realm.add(object)
          }
    }

    func update<T: Object>(_ object: T) {
        try? realm.write {
            realm.add(object, update: .modified)
        }
    }

    func delete<T: Object>(_ object: T) {
        try? realm.write {
            realm.delete(object)
        }
    }
}
