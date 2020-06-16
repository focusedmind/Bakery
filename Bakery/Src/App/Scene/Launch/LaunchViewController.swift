//
//  LaunchViewController.swift
//  Bakery
//
//  Created by iOS Developer on 6/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.alpha = 0
        }
    }
    
    private lazy var logos = (1...11).map({ "logo\($0)" })
        .compactMap(UIImage.init(named:))
        .shuffled()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = logos.first
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, animations: {
            self.imageView.alpha = 1
        }) { _ in
            self.perform(#selector(self.openProductsScene), with: nil, afterDelay: 0.3)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func openProductsScene() {
        ProductsRouter.open(in: self.navigationController!)
    }
}
