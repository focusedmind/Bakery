//
//  TokenGateway.swift
//  Bakery
//
//  Created by iOS Developer on 4/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation

protocol TokenGateway {
    
    var credentials: TokenEntity? { get set }
    var constantApiKey: String { get }
}
