//
//  Created by CavistaCodeChallenge
//  Copyright © CavistaCodeChallenge All rights reserved.
//  Created on 30/08/20

import Foundation
import RealmSwift

public class MyItemDetails: Object, Codable {
    @objc dynamic var id: String?
    @objc dynamic var type: String?
    @objc dynamic var createdDate: String?
    @objc dynamic var details: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case createdDate = "date"
        case details = "data"
    }
    
    public override static func primaryKey() -> String? { return "id" }
}
