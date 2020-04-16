//
//  ViewController.swift
//  Bakery
//
//  Created by iOS Developer on 4/10/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import UIKit
import Foundation
import Moya
import RxSwift


class TestApiGateway: BaseApiGateway<Backend> {
    
    func getGoogle() -> Single<Data> {
        return self.client.execute(request: .test)
    }
}

class ViewController: UIViewController {
    
    var testGateway: TestApiGateway!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
