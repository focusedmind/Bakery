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
}


extension Backend: TargetType {
    
    public var baseURL: URL { return URL(string: "http://localhost")! }
    
    public var path: String {
        switch self {
        case .signIn(_):
            return "/login"
        case .test:
            return ""
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
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .signIn(_), .test:
            return .none
        default:
            return .bearer
        }
    }
}
