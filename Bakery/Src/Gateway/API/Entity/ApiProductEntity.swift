//
//  ApiProductEntity.swift
//  Bakery
//
//  Created by iOS Developer on 6/10/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation

struct ApiProductEntity: ApiPaginationItem, Decodable {
    
    let id: Int
    let title: String
    let image: String
    let imageType: String
    
    static let itemsContainerCodingKey = "products"
    static let totalCountCodingKey = "totalProducts"
}

extension ApiProductEntity: TransformableEntity {
    
    typealias CleanEntityType = ProductEntity
    
    var domainEntity: ProductEntity {
        return ProductEntity(id: self.id, title: self.title, thumbnailURL: URL(string: self.image)!)
    }
    
}
