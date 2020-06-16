//
//  BaseRouter.swift
//  Bakery
//
//  Created by iOS Developer on 4/14/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import UIKit


protocol BaseRouter {
    
    var view: UIViewController! { get }
    
    init(_ view: UIViewController)
    func close()
    func closeToRoot()
}


extension BaseRouter {
    
    func close() {
        guard let naviController = self.view?.navigationController else { return }
        naviController.popViewController(animated: true)
    }
    
    func closeToRoot() {
        guard let naviController = self.view?.navigationController else { return }
        naviController.popToRootViewController(animated: true)
    }
}
