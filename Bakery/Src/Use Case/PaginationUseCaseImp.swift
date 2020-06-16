//
//  PaginationUseCaseImp.swift
//  Bakery
//
//  Created by iOS Developer on 6/13/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import RxSwift


class PaginationUseCaseImp<RemoteItemType: ApiEntityType>: PaginationUseCase {
    
    typealias Element = RemoteItemType
    
    private(set) var eventPublisher: PublishSubject<PagationUseCaseEvent<RemoteItemType.CleanEntityType>>
    private(set) var isLoadingItems = false
    /// for using after local db implementation
    private(set) var dataSourceKind: DataSourceKind = .remote

    private var remoteGateway: BaseApiPaginationGateway<RemoteItemType>
    private var paginatedItems: PaginationEntity<RemoteItemType.CleanEntityType>
    private var pageSize: Int
    private var query: String? = nil
    private var disposeBag = DisposeBag()
    private var processingQueue = ConcurrentDispatchQueueScheduler(qos: .utility)
    
    var items: [RemoteItemType.CleanEntityType] { return paginatedItems.items }
    var numberOfItems: Int { return items.count }
    var hasMoreUnloadedItems: Bool { return self.paginatedItems.totalCount > self.numberOfItems}
    
    
    init(remoteGateway: BaseApiPaginationGateway<RemoteItemType>, pageSize: Int = 20) {
        self.remoteGateway = remoteGateway
        self.eventPublisher = .init()
        self.pageSize = pageSize
        self.paginatedItems = .init(items: [], totalCount: 0, pageSize: self.pageSize, offset: 0)
    }
    
    func reloadItems(query: String? = nil) {
        self.disposeBag = DisposeBag()
        self.query = query
        self.loadItems()
    }
    
    @discardableResult
    func loadNextPage() -> Bool {
        guard self.hasMoreUnloadedItems else { return false }
        if !self.isLoadingItems {
            self.loadItems(offset: self.numberOfItems)
        }
        return true
    }
    
    private func loadItems(offset: Int = 0)  {
        self.remoteGateway.loadItems(offset: offset, pageSize: self.pageSize, query: self.query)
            .subscribeOn(self.processingQueue)
            .observeOn(self.processingQueue)
            .do(afterSuccess: { [weak self] result in self?.publishLoadedItems(with: offset,
                                                                               loadedItems: result.items)},
                onSubscribe: { [weak self] in self?.isLoadingItems = true },
                onDispose: { [weak self] in self?.isLoadingItems = false })
            .subscribe(onSuccess: { [weak self] result in
                guard let self = self else { return }
                if offset == 0 {
                    self.paginatedItems.items.removeAll()
                }
                self.paginatedItems.update(with: result)
            }, onError: { [weak self] error in
                self?.eventPublisher.onNext(.errorReceived(error: error))
            }).disposed(by: self.disposeBag)

    }
    
    private func publishLoadedItems(with offset: Int, loadedItems: [RemoteItemType]) {
        let isLoadedFirstPage = offset == 0
        let isResultNotEmpty = !loadedItems.isEmpty
        if isLoadedFirstPage {
            self.eventPublisher.onNext(isResultNotEmpty ? .itemsLoaded(items: loadedItems.map({ $0.domainEntity })) : .emptyMessageReceived)
        } else {
            if isResultNotEmpty && offset < self.numberOfItems {
                let loadedRange = Range(uncheckedBounds: (lower: offset, upper: self.numberOfItems))
                self.eventPublisher.onNext(.nextPageLoaded(items: loadedItems.map({ $0.domainEntity }),
                                                           pageRange: loadedRange))
            } else {
                // when happened something extraordinary just to say reloaded all items
                self.eventPublisher.onNext(.itemsLoaded(items: self.items))
            }
        }
    }
    
    private func initializePaginatedItems() {
        self.paginatedItems = .init(items: [], totalCount: 0, pageSize: self.pageSize, offset: 0)
    }
}
