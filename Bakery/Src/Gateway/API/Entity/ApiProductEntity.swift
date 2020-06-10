//
//  ApiProductEntity.swift
//  Bakery
//
//  Created by iOS Developer on 6/10/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation

struct ApiProductEntity: Decodable {
    
    let id: Int
    let title: String
    let image: String
    let imageType: String
}
