//
//  ApiClient.swift
//  Bakery
//
//  Created by iOS Developer on 4/13/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol ApiClient {
    
    associatedtype TargetService: TargetType
    func execute<ResponseType: Decodable>(request: TargetService) -> Single<ResponseType>
}


class BaseApiClient<TargetService: TargetType>: ApiClient {
    
    internal let provider: MoyaProvider<TargetService>
    internal let jsonDecoder = JSONDecoder()
    
    init(additionalHeaders: [String : String] = [:],
         plugins: [PluginType] = []) {
        let endpointClosure = { (target: TargetService) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint.adding(newHTTPHeaderFields: additionalHeaders)
        }
        self.provider = MoyaProvider<TargetService>(endpointClosure: endpointClosure, plugins: plugins)
    }
    
    func execute<ResponseType: Decodable>(request: TargetService) -> Single<ResponseType> {        
        return self.provider.rx.request(request)
            .filterSuccessfulStatusCodes()
            .map { (response) -> ResponseType in
                switch ResponseType.self {
                case let rType where rType == String.self:
                    return try response.mapString() as! ResponseType
                case let rType where rType == Data.self:
                    return response.data as! ResponseType
                default:
                    return try response.map(ResponseType.self)
            }
        }
    }
}

struct ApiClientFactory {
    
    static func createDefaultInstanceForBackend(tokenGateway: TokenGateway) -> BaseApiClient<Backend> {
        let additionalHeaders = [
            "clientType": "ios",
            "appVersion": Bundle.main.versionNumber,
            "locale": Locale.current.languageCode ?? "en"
        ]
        let authPlugin = AccessTokenPlugin { (authType) -> String in
            return tokenGateway.credentials?.accessToken ?? ""
        }
        let jsonResponseDataFormatter = { (data: Data) -> String in
            do {
                let dataAsJSON = try JSONSerialization.jsonObject(with: data)
                let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
                return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
            } catch {
                return String(data: data, encoding: .utf8) ?? ""
            }
        }
        let loggingPlugin = NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: jsonResponseDataFormatter),
                                                                     logOptions: .default))
        return BaseApiClient<Backend>(additionalHeaders: additionalHeaders,
                                      plugins: [authPlugin, loggingPlugin])
    }
}
