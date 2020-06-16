//
//  ProductsCVCell.swift
//  Bakery
//
//  Created by iOS Developer on 6/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import UIKit
import Kingfisher

class ProductsCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.kf.cancelDownloadTask()
        self.imageView.image = nil
    }
    
    func setup(_ entity: ProductEntity) {
        self.descLabel.text = entity.title
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: entity.thumbnailURL,
                                   placeholder: nil,
                                   options: [.transition(.fade(0.3))])
    }
    
}
