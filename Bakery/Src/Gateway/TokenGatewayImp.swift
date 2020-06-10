//
//  TokenGatewayImp.swift
//  Bakery
//
//  Created by iOS Developer on 4/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import KeychainAccess


class TokenGatewaImp: TokenGateway {
    
    private let keychain = Keychain()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let tokenEntityKey = "token"
    private var cachedEntity: TokenEntity?
    
    var credentials: TokenEntity? {
        get {
            if let result = self.cachedEntity {
                return result
            } else if let tokenData: Data = self.keychain[data: tokenEntityKey],
                      let result = try? self.decoder.decode(TokenEntity.self, from: tokenData) {
                self.cachedEntity = result
                return result
            } else { return nil }
        }
        set {
            if let notNullNewValue = newValue {
                let tokenData = try! self.encoder.encode(notNullNewValue)
                self.keychain[data: tokenEntityKey] = tokenData
                self.cachedEntity = notNullNewValue
            } else {
                self.keychain[data: tokenEntityKey] = nil
                self.cachedEntity = nil
            }
        }
    }
    
    // temp solution due to lack of normal auth on spoonacular API.
    var constantApiKey: String { return "afd19d44b0104b38bb999ab9d7d65dc6" }
}
