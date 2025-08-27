//
//  RealmManager.swift
//  paymobTask
//
//  Created by Rawan Ashraf on 26/08/2025.
//

import Foundation
import RealmSwift

public final class RealmManager {
    public static let shared = RealmManager()
    private let realm: Realm
    
    private init() {
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm()
    }
    
    public func getRealm() -> Realm {
        return realm
    }
}
