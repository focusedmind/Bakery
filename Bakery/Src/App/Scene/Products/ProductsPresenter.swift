//
//  ProductsPresenter.swift
//  Bakery
//
//  Created by iOS Developer on 6/15/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import RxSwift

protocol ProductsPresenter {
    
    func onViewDidLoad()
    func reloadItems()
    func numberOfItems(in section: Int) -> Int
    func headerEntity(for section: Int) -> ProductsListCVHeaderEntity
    func cellEntity(for indexPath: IndexPath) -> ProductEntity
    func viwWillDisplaySupplementaryView(at indexPath: IndexPath, kind: String)
    
    var isLoadingItems: Bool { get }
    var numberOfSections: Int { get }
}

protocol ProductsView: BaseView {
    
    func reloadItems()
    func handleItemsListUpdate(_ event: ItemsListUpdateEvent)
    func endRefreshing()
}


class ProductsPresenterImp: ProductsPresenter {
    
    //In fact the type is PaginationUseCase, but it can not be declared due to having associatedType
    private let dataSource: PaginationUseCaseImp<ApiProductEntity>
    private let router: BaseRouter
    private weak var view: ProductsView!
    private let disposeBag = DisposeBag()
    private let headers: [ProductsListCVHeaderEntity]
    
    var isLoadingItems: Bool { return self.dataSource.isLoadingItems }
    var numberOfSections: Int { return 1 }
    
    init(view: ProductsView, router: BaseRouter, dataSource: PaginationUseCaseImp<ApiProductEntity>) {
        self.view = view
        self.router = router
        self.dataSource = dataSource
        self.headers = [ProductsListCVHeaderEntity(isRevealed: true, sectionTitle: "Products")]
    }
    
    func onViewDidLoad() {
        self.dataSource.eventPublisher
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (dataSourceEvent) in
                guard let self = self else { return }
                switch dataSourceEvent {
                case .emptyMessageReceived:
                    self.view.showInfoMessage("List is empty", action: { [weak self] in
                        self?.view.endRefreshing()
                    })
                case .itemsLoaded(_:):
                    self.view.reloadItems()
                case .nextPageLoaded(_, let itemsRange):
                    let indices = itemsRange.map({ IndexPath(item: $0, section: 0)})
                    self.view.handleItemsListUpdate(.append(indices))
                case .errorReceived(let error):
                    self.view.showInfoMessage(error.localizedDescription + "\nTry to refresh by pulling down.", action: { [weak self] in
                        self?.view.endRefreshing()
                    })
                }
            }, onError: { [weak self] (error) in
                self?.view.showInfoMessage(error.localizedDescription + "\nTry again later.", action: { [weak self] in
                    self?.view.endRefreshing()
                })
            }).disposed(by: self.disposeBag)
        
        // "a" - just because spoonacular API doesn't allow to get list with empty query
        self.reloadItems()
    }
    
    func reloadItems() {
        self.dataSource.reloadItems(query: "a")
    }
    
    func numberOfItems(in section: Int) -> Int {
        return section == 0 ? self.dataSource.numberOfItems : 0
    }
    
    func headerEntity(for section: Int) -> ProductsListCVHeaderEntity {
        return self.headers[section]
    }
    
    func cellEntity(for indexPath: IndexPath) -> ProductEntity {
        return self.dataSource.items[indexPath.item]
    }
    
    func viwWillDisplaySupplementaryView(at indexPath: IndexPath, kind: String) {
        //load next page if can, when user is reached bottom of section
        guard kind == UICollectionView.elementKindSectionFooter else { return }
        guard self.headers[indexPath.section].isRevealed else { return }
        self.dataSource.loadNextPage()
    }
}
