//
//  PaginationEntity.swift
//  Bakery
//
//  Created by iOS Developer on 6/10/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation

protocol PaginationItem {
    
    static var itemsContainerCodingKey: String { get }
    static var totalCountCodingKey: String { get }
}

struct PaginationEntity<Element: PaginationItem> {
    
    let items: [Element]
    let totalCount: Int
    let pageSize: Int
    let skip: Int
}

//this is required because CodingKey for items and totalItems are dynamic and depends on the type of Element
fileprivate struct GenericCodingKeys: CodingKey {
    
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) { self.stringValue = stringValue }
    init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)" }
}


extension PaginationEntity: Decodable where Element: Decodable {
    
    fileprivate enum ConstantCodingKeys: String, CodingKey {
        case pageSize = "number"
        case skip
        
        var genericCodingKey: GenericCodingKeys { return GenericCodingKeys(stringValue: self.rawValue) }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GenericCodingKeys.self)
        self.pageSize = try container.decode(Int.self,
                                             forKey: ConstantCodingKeys.pageSize.genericCodingKey)
        self.skip = try container.decode(Int.self,
                                         forKey: ConstantCodingKeys.skip.genericCodingKey)
        self.items = try container.decode([Element].self,
                                          forKey: GenericCodingKeys(stringValue: Element.itemsContainerCodingKey))
        self.totalCount = try container.decode(Int.self, forKey: GenericCodingKeys(stringValue: Element.totalCountCodingKey))
    }
}
