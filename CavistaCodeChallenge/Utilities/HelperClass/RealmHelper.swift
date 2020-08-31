//
//  Created by CavistaCodeChallenge
//  Copyright © CavistaCodeChallenge All rights reserved.
//  Created on 31/08/20

import UIKit
import RealmSwift

class RealmHelper: NSObject {
    
    static let realmManager = RealmHelper()
    
    private let realm = try? Realm()
    
    /// Default Configration For realm database
    public func configration() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
        })
        if let fileUrl = Realm.Configuration.defaultConfiguration.fileURL{
            print("Default Realm file location url",fileUrl)
        }
    }
    
    /// Save object to the table
    private func saveObjects(objs: Object) {
        try? realm!.write ({
            realm?.add(objs, update: .all)
        })
    }
    
    /// Save object to the table
    private func deleteAllObjects() {
        try? realm!.write ({
            realm?.deleteAll()
            print("=====Record Deleted successfully=====")
        })
    }
    
    /// Returs an array as Results<object>?
    private func getObjects(type: Object.Type) -> Results<Object>? {
        return realm!.objects(type)
    }
    
    // fetch all the objects in table
    public func addAllItemInToDB(to items: [MyItemDetails]) {
        deleteAllObjects()
        items.forEach { myItemDetails in
            saveObjects(objs: myItemDetails)
        }
    }
    
    /// fetch all the objects in table
    public func getAllMyList() -> [MyItemDetails] {
        var myItemDetails = [MyItemDetails]()
        if let objects = getObjects(type: MyItemDetails.self) {
            for element in objects {
                if let myItemDetail = element as? MyItemDetails {
                    myItemDetails.append(myItemDetail)
                }
            }
        }
        print("Total count is:- \(myItemDetails.count)")
        return myItemDetails
    }
}
