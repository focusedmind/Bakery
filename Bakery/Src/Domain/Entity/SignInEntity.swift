//
//  SignInEntity.swift
//  Bakery
//
//  Created by iOS Developer on 4/14/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation

struct SignInEntity: Codable {
    
    let login: String
    let password: String
    let capcha: String? = nil
}
