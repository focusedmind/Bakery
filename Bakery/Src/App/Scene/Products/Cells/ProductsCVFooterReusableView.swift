//
//  ProductsCVFooterReusableView.swift
//  Bakery
//
//  Created by iOS Developer on 6/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import UIKit

class ProductsCVFooterReusableView: UICollectionReusableView {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    func setup(isAnimating: Bool) {
        if isAnimating {
            self.loadingIndicator.startAnimating()
        } else {
            self.loadingIndicator.stopAnimating()
        }
    }
        
}
