//
//  Created by CavistaCodeChallenge
//  Copyright © CavistaCodeChallenge All rights reserved.
//  Created on 30/08/20

import Foundation

class MyListViewModel: NSObject {
    public private(set) var myItemList: [MyItemDetails]?
    
    /// Call My List API
    /// - Parameter completion: completion value for error if any
    public func callSignInAPI(completion: @escaping (String?) -> Void) {
        Network.request(url: API.URL.getList) { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion("Something went wrong")
                    return
                }
                do {
                    let itemRequest = try JSONDecoder().decode([MyItemDetails].self, from: data)
                    self?.myItemList = itemRequest.filter({ cavistaDetail -> Bool in
                        return cavistaDetail.createdDate != nil && cavistaDetail.details != nil
                    })
                    completion(nil)
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                completion(error.errorDescription)
            }
        }
    }
    
    /// AddUpdate Data to the Database
    public func addUpdateDataToDB() {
        guard let myItemList = myItemList else { return }
        DispatchQueue.main.async {
            RealmHelper.realmManager.addAllItemInToDB(to: myItemList)
        }
    }
    
    /// Get All Data from the Database
    public func fetchDataFromDB() {
        myItemList = RealmHelper.realmManager.getAllMyList()
    }
}
