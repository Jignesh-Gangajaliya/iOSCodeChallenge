//
//  Created by CavistaCodeChallenge
//  Copyright © CavistaCodeChallenge All rights reserved.
//  Created on 01/09/20


import Foundation

struct Constant {
    struct Message {
        static let saveError = "Save error"
        static let saved = "Saved"
        static let savedMessage = "Your altered image has been saved to your photos."
        static let fetchError = "No Data added locally"
        static let ok = "OK"
    }
}

struct Cell {
    static let cavistaImageCell = "CavistaImageCell"
    static let cavistaDetailsCell = "CavistaDetailsCell"
}

enum DetailType: String {
    case image = "image"
}
