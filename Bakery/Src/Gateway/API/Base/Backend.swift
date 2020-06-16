//
//  BackendRequest.swift
//  Bakery
//
//  Created by iOS Developer on 4/14/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import Foundation
import Moya

enum Backend {
    
    case signIn(credentials: SignInEntity)
    case test
    case products(query: String, offset: Int, pageSize: Int)
}


extension Backend: TargetType {
    
    public var baseURL: URL { return URL(string: "https://api.spoonacular.com")! }
    
    //temp solution until spoonacular API get normal auth via headers
    private var tokenGateway: TokenGateway { return  TokenGatewaImp.default }
    
    public var path: String {
        switch self {
        case .signIn(_):
            return "/login"
        case .test:
            return ""
        case .products(_, _, _):
            return "food/products/search"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .signIn(_):
            return .post
        default:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .signIn(let credentials):
            return .requestJSONEncodable(credentials)
        case .test:
            return .requestPlain
        case .products(let query, let offset, let pageSize):
            return .requestParameters(parameters: ["query": query,
                                                   "offset": offset, "number": pageSize,
                                                   "apiKey": tokenGateway.constantApiKey],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .signIn(_):
            return "\"token\": \"JWTToken\"".data(using: .utf8)!
        default:
            return Data()
        }
    }
}

extension Backend: AccessTokenAuthorizable {
    
    /// API uses only static apiKey for auth as query string
    var authorizationType: AuthorizationType? {
        
        return .none
//        switch self {
//        case .signIn(_), .test:
//            return .none
//        default:
//            return .bearer
//        }
    }
}
