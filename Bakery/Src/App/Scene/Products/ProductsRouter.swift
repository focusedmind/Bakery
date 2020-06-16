//
//  ProductsRouter.swift
//  Bakery
//
//  Created by iOS Developer on 6/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import UIKit

class ProductsRouter: BaseRouter {
    
    internal var view: UIViewController!
    
    required init(_ view: UIViewController) {
        self.view = view
    }
    
    class func open(in naviController: UINavigationController) {
        let vc = R.storyboard.main.productsCVController()!
        ProductsConfigurator.configure(vc)
        naviController.setViewControllers([vc], animated: true)
    }
}
