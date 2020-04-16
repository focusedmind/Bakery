//
//  BaseApiGateway.swift
//  Bakery
//
//  Created by iOS Developer on 4/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import Moya

class BaseApiGateway<TargetService: TargetType> {
    
    internal let client: BaseApiClient<TargetService>
    
    init(_ client: BaseApiClient<TargetService>) {
        self.client = client
    }
}
