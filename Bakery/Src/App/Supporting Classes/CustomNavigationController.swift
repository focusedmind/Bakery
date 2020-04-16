//
//  CustomNavigationController.swift
//  Bakery
//
//  Created by iOS Developer on 4/14/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //allows back-swipe gesture
        interactivePopGestureRecognizer?.delegate = self
    }
    
    func becomeTransparent() {
        // Transparent navigation bar
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }
}

extension CustomNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
