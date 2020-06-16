//
//  PaginationUseCase.swift
//  Bakery
//
//  Created by iOS Developer on 6/13/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import RxSwift

protocol TransformableEntity {
    
    associatedtype CleanEntityType
    
    var domainEntity: CleanEntityType { get }
}

protocol PaginationUseCase {
    
    associatedtype Element: TransformableEntity
    
    var items: [Element.CleanEntityType] { get }
    var numberOfItems: Int { get }
    var hasMoreUnloadedItems: Bool { get }
    var isLoadingItems: Bool { get }
    var dataSourceKind: DataSourceKind { get }
    
    var eventPublisher: PublishSubject<PagationUseCaseEvent<Element.CleanEntityType>> { get }
    
    func reloadItems(query: String?)
    @discardableResult
    func loadNextPage() -> Bool
}

enum PagationUseCaseEvent<Element> {
    
    case itemsLoaded(items: [Element])
    case nextPageLoaded(items: [Element], pageRange: Range<Int>)
    case emptyMessageReceived
    case errorReceived(error: Error)
}

enum DataSourceKind {
    
    case remote
    case local
}
