//
//  Created by CavistaCodeChallenge
//  Copyright © CavistaCodeChallenge All rights reserved.
//  Created on 02/09/20


import XCTest
@testable import CavistaCodeChallenge

class CavistaCodeChallengeTests: XCTestCase {
    
    private var viewModel: MyListViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = MyListViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    // this test load data from API and stored in local DB
    func test_list_data_online_offline() {
        let expec = expectation(description: "API Call")
        viewModel?.callSignInAPI(completion: { [weak self] (error) in
            expec.fulfill()
            guard let error = error else {
                XCTAssert(self?.viewModel?.myItemList?.count ?? 0 != 0, "Data not available")
                self?.viewModel?.addUpdateDataToDB()
                return
            }
            XCTAssert(false, error)
            print("API Response error:- \(error)")
        })
        wait(for: [expec], timeout: 10)
    }

    // this test cases to check data is available in DB or not
    func test_load_offline_data() {
        viewModel?.fetchDataFromDB()
        XCTAssert(viewModel?.myItemList?.count ?? 0 != 0, "Data not available")
    }
}
