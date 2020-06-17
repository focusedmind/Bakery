//
//  ProductsCVHeaderView.swift
//  Bakery
//
//  Created by iOS Developer on 6/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import UIKit


protocol ProductsCVHeaderViewDelegate: class {
    
    func onHeaderTouched(_ header: ProductsCVHeaderView, at index: Int)
}

protocol ProductsCVHeader: class {
    
    func setup(_ config: ProductsListCVHeaderEntity, delegate: ProductsCVHeaderViewDelegate, sectionIndex: Int)
    func updateState(_ newConfig: ProductsListCVHeaderEntity, shouldReveal: Bool)
}


class ProductsCVHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionTitleImageView: UIImageView!

    private weak var delegate: ProductsCVHeaderViewDelegate?
    /// index of section
    private var index: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.onSectionTitleViewTouched(_:)))
        self.addGestureRecognizer(tapGR)
    }
    
    override func prepareForReuse() {
        self.sectionTitleImageView.transform = CGAffineTransform(rotationAngle: 0)
        super.prepareForReuse()
    }
    
    @objc private func onSectionTitleViewTouched(_ recognizer: UITapGestureRecognizer) {
        self.delegate?.onHeaderTouched(self, at: self.index)
    }
}


extension ProductsCVHeaderView: ProductsCVHeader {
    
    func setup(_ config: ProductsListCVHeaderEntity, delegate: ProductsCVHeaderViewDelegate, sectionIndex: Int) {
        self.delegate = delegate
        self.index = sectionIndex
        self.sectionTitleLabel.text = config.sectionTitle
        let transformAngle = config.isRevealed ? 0 : -CGFloat.pi/2
        self.sectionTitleImageView.transform = CGAffineTransform(rotationAngle: transformAngle)
    }
    
    func updateState(_ newConfig: ProductsListCVHeaderEntity, shouldReveal: Bool) {
        let transformAngle = newConfig.isRevealed ? 0 : -CGFloat.pi/2
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.sectionTitleImageView.transform = CGAffineTransform(rotationAngle: transformAngle)
        })
    }
}
