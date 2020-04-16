//
//  AuthResponseEntity.swift
//  Bakery
//
//  Created by iOS Developer on 4/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation

struct AuthResponseEntity: Decodable {
    
    let token: TokenEntity
    let user: UserEntity
}
