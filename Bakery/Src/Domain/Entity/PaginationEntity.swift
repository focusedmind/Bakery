//
//  PaginationEntity.swift
//  Bakery
//
//  Created by iOS Developer on 6/10/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation

protocol ApiPaginationItem: Decodable {
    
    static var itemsContainerCodingKey: String { get }
    static var totalCountCodingKey: String { get }
}

struct PaginationEntity<Element> {
    
    var items: [Element]
    var totalCount: Int
    var pageSize: Int
    var offset: Int
    
    mutating func update(with nextPage: Self) {
        self.items.append(contentsOf: nextPage.items)
        self.totalCount = nextPage.totalCount
        self.pageSize = nextPage.pageSize
        self.offset = nextPage.offset
    }
    
    mutating func update<Transformable: TransformableEntity>(with nextPage: PaginationEntity<Transformable>)
        where Transformable.CleanEntityType == Element {
            self.items.append(contentsOf: nextPage.items.map({ $0.domainEntity }))
            self.totalCount = nextPage.totalCount
            self.pageSize = nextPage.pageSize
            self.offset = nextPage.offset
    }
}
