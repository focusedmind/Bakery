//
//  ProductsConfigurator.swift
//  Bakery
//
//  Created by iOS Developer on 6/16/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation


class ProductsConfigurator {
    
    class func configure(_ view: ProductsCVController) {
        // MARK: TODO by Ard
        // implement DI and resolve all this stuff using it
        let router = ProductsRouter(view)
        let tokenGateway = TokenGatewaImp()
        let apiGateway = ApiProductsGateway(ApiClientFactory.createDefaultInstanceForBackend(tokenGateway: tokenGateway))
        let dataSource = PaginationUseCaseImp(remoteGateway: apiGateway)
        let presenter = ProductsPresenterImp(view: view, router: router, dataSource: dataSource)
        view.presenter = presenter
    }
}
