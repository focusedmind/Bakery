//
//  ApiErrorEntity.swift
//  Bakery
//
//  Created by iOS Developer on 6/10/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation

struct ApiErrorEntity: Error, Codable {
    
    let message: String
    let status: String
    let code: Int
    
    var localizedDescription: String {
        return message
    }
}
