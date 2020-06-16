//
//  ProductsCVController.swift
//  Bakery
//
//  Created by iOS Developer on 6/15/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import UIKit

class ProductsCVController: UICollectionViewController, BaseView {

    // MARK: UI elements
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let result = UIRefreshControl()
        result.addTarget(self, action: #selector(self.onRefreshPulled(_:)), for: .valueChanged)
        return result
    }()
    // MARK: Variables
    fileprivate lazy var itemWidth: CGFloat = { return self.getItemWidth() }()
    
    // MARK: Computed properties
    fileprivate var numberOfItemsInLine: Int {
        return self.view.frame.height > self.view.frame.width ? 2 : 4
    }
    fileprivate var sizingView: ProductsCVCell!
    fileprivate var sizingViewWidthConstraint: NSLayoutConstraint!
    
    fileprivate static let productsCVCellReuseIdentifier = "productCVCell"
    
    var presenter: ProductsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero
        }
        self.sizingView = R.nib.productsCellXibView(owner: nil)
        self.sizingViewWidthConstraint = self.sizingView.widthAnchor.constraint(equalToConstant: self.itemWidth)
        self.sizingViewWidthConstraint.isActive = true
        self.collectionView.register(UINib(resource: R.nib.productsCellXibView),
                                     forCellWithReuseIdentifier: Self.productsCVCellReuseIdentifier)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.refreshControl = self.refreshControl
        self.collectionView.refreshControl!.beginRefreshing()
        self.presenter.onViewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.handleTransitionToNewSize()
        }, completion: nil)
    }
    
    @objc private func onRefreshPulled(_ sender: UIRefreshControl) {
        self.presenter.reloadItems()
    }
    
    
    /// Calculates item width for all cells based on  current orientation and CollectionVIewLayout properties
    /// - Returns: width of all cells
    fileprivate func getItemWidth() -> CGFloat {
        let itemCountInLine = CGFloat(self.numberOfItemsInLine)
        let currentLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let interItemSpacing = currentLayout.minimumInteritemSpacing
        let sectionTotalHorizontalInset = currentLayout.sectionInset.left + currentLayout.sectionInset.right
        let safeAreaTotalInsets = self.view.safeAreaInsets.left + self.view.safeAreaInsets.right
        let lineWidthWithoutIndentAndInsets = self.collectionView.frame.width - safeAreaTotalInsets - (itemCountInLine - 1) * interItemSpacing - sectionTotalHorizontalInset - 4
        return lineWidthWithoutIndentAndInsets / itemCountInLine
    }
    
    fileprivate func handleTransitionToNewSize() {
        self.itemWidth = self.getItemWidth()
        self.sizingViewWidthConstraint.constant = self.itemWidth
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension ProductsCVController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if !self.presenter.isLoadingItems && self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        return self.presenter.numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.headerEntity(for: section).isRevealed ? self.presenter.numberOfItems(in: section) : 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.productsCVCellReuseIdentifier,
                                                      for: indexPath) as! ProductsCVCell
        cell.setup(self.presenter.cellEntity(for: indexPath))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: R.reuseIdentifier.productsCVFooterReusableView,
                                                                         for: indexPath)!
            self.presenter.viwWillDisplaySupplementaryView(at: indexPath, kind: kind)
            let isLoadingIndicatorVisible = self.presenter.isLoadingItems && !self.refreshControl.isRefreshing
            footer.setup(isAnimating: isLoadingIndicatorVisible)
            return footer
        } 
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: R.reuseIdentifier.productsCVHeaderView,
                                                                         for: indexPath)!
        headerView.setup(self.presenter.headerEntity(for: indexPath.section),
                         delegate: self,
                         sectionIndex: indexPath.section)
        return headerView
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension ProductsCVController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Get the view for the first header
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView,
                                             viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                             at: indexPath)
        // Use this view to calculate the optimal size based on the collection view's width
        let size = headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingCompressedSize.height),
                                                        withHorizontalFittingPriority: .required, // Width is fixed
                                                        verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        let sectionCount = self.numberOfSections(in: collectionView)
        guard sectionCount == 0 || section == (sectionCount - 1) else {
            return .zero
        }
        return CGSize(width: 77, height: 77)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let entity = self.presenter.cellEntity(for: indexPath)
        self.sizingView.setup(entity)
        self.sizingView.setNeedsLayout()
        self.sizingView.layoutIfNeeded()
        let desiredSize = CGSize(width: self.itemWidth, height: UIView.layoutFittingExpandedSize.height)
        let size = sizingView.systemLayoutSizeFitting(desiredSize,
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .fittingSizeLevel)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let verticalInset: CGFloat = self.presenter.headerEntity(for: section).isRevealed ? 10 : 0
        return UIEdgeInsets(top: verticalInset, left: 16, bottom: verticalInset, right: 16)
    }
}

// MARK: ProductsCVHeaderViewDelegate
extension ProductsCVController: ProductsCVHeaderViewDelegate {
    
    func onHeaderTouched(_ header: ProductsCVHeaderView, at index: Int) {
        let headerEntity = self.presenter.headerEntity(for: index)
        let shouldReveal = !headerEntity.isRevealed
        headerEntity.isRevealed = shouldReveal
        header.updateState(headerEntity, shouldReveal: shouldReveal)
        let numberOfCellsInSection = self.presenter.numberOfItems(in: index)
        if numberOfCellsInSection > 0 {
            let indicesOfCellsInThisSection = (0..<numberOfCellsInSection).map({ IndexPath(item: $0, section: index)})
            self.collectionView.performBatchUpdates({ [weak self] in
                    if shouldReveal {
                        self?.collectionView.insertItems(at: indicesOfCellsInThisSection)
                    } else {
                        self?.collectionView.deleteItems(at: indicesOfCellsInThisSection)
                    }
            })
        }
    }
}

extension ProductsCVController: ProductsView {
    
    func reloadItems() {
        self.collectionView.reloadData()
    }
    
    func handleItemsListUpdate(_ event: ItemsListUpdateEvent) {
        self.collectionView.performBatchUpdates({ [weak self] in
            switch event {
            case .append(let indices):
                self?.collectionView.insertItems(at: indices)
            case .remove(let indices):
                self?.collectionView.deleteItems(at: indices)
            case .update(let indices):
                self?.collectionView.reloadItems(at: indices)
            }
        })
    }
    
    func endRefreshing() {
        self.refreshControl.endRefreshing()
    }
}

