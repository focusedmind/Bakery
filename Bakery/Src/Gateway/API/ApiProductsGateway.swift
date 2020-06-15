//
//  ApiProductsGateway.swift
//  Bakery
//
//  Created by iOS Developer on 6/13/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import RxSwift

class ApiProductsGateway: BaseApiPaginationGateway<ApiProductEntity> {
    
    override func loadItems(offset: Int, pageSize: Int, query: String?) -> Single<PaginationEntity<ApiProductEntity>> {
        return self.client.execute(request: .products(query: query ?? "", skip: offset, pageSize: pageSize))
    }
}
