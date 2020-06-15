//
//  AuthGatewayImp.swift
//  Bakery
//
//  Created by iOS Developer on 4/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import RxSwift

class ApiAuthGateway: BaseApiGateway<Backend>, AuthGateway {
        
    func signIn(credentials: SignInEntity) -> Single<AuthResponseEntity> {
        return self.client.execute(request: .signIn(credentials: credentials))
    }
}
