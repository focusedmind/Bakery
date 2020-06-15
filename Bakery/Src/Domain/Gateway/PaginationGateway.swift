//
//  PaginationGateway.swift
//  Bakery
//
//  Created by iOS Developer on 6/12/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import RxSwift


protocol PaginationGateway {
    
    associatedtype Element: TransformableEntity
    
    func loadItems(offset: Int, pageSize: Int, query: String?) -> Single<PaginationEntity<Element>>
}
