//
//  AuthGateway.swift
//  Bakery
//
//  Created by iOS Developer on 4/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthGateway {
    
    func signIn(credentials: SignInEntity) -> Single<AuthResponseEntity>
}
