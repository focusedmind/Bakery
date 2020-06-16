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

//this is required because CodingKey for items and totalItems are dynamic and depends on the type of Element
fileprivate struct GenericCodingKeys: CodingKey {
    
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
}


extension PaginationEntity: Decodable where Element: ApiPaginationItem  {
    
    fileprivate enum ConstantCodingKeys: String, CodingKey {
        case pageSize = "number"
        case offset
        
        var genericCodingKey: GenericCodingKeys { return GenericCodingKeys(stringValue: self.rawValue) }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GenericCodingKeys.self)
        self.pageSize = try container.decode(Int.self,
                                             forKey: ConstantCodingKeys.pageSize.genericCodingKey)
        self.offset = try container.decode(Int.self,
                                         forKey: ConstantCodingKeys.offset.genericCodingKey)
        self.items = try container.decode([Element].self,
                                          forKey: GenericCodingKeys(stringValue: Element.itemsContainerCodingKey))
        self.totalCount = try container.decode(Int.self,
                                               forKey: GenericCodingKeys(stringValue: Element.totalCountCodingKey))
    }
}
