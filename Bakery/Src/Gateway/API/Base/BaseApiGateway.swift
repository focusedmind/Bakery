//
//  BaseApiGateway.swift
//  Bakery
//
//  Created by iOS Developer on 4/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class BaseApiGateway<TargetService: TargetType> {
    
    internal let client: BaseApiClient<TargetService>
    
    init(_ client: BaseApiClient<TargetService>) {
        self.client = client
    }
}

typealias ApiEntityType = ApiPaginationItem & TransformableEntity

class BaseApiPaginationGateway<ApiElementType: ApiEntityType>: BaseApiGateway<Backend>, PaginationGateway  {

    typealias Element = ApiElementType
    
    func loadItems(offset: Int, pageSize: Int, query: String?) -> Single<PaginationEntity<ApiElementType>> {
        fatalError("You should override BaseApiPaginationGateway.loadItems method in all subclasses.")
    }
}
