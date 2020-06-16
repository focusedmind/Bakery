//
//  ProductsListCVHeaderEntity.swift
//  Bakery
//
//  Created by iOS Developer on 6/15/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation

class ProductsListCVHeaderEntity: Codable {
    
    var isRevealed: Bool
    var sectionTitle: String
    
    init(isRevealed: Bool, sectionTitle: String) {
        self.isRevealed = isRevealed
        self.sectionTitle = sectionTitle
    }
}
