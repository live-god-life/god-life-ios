//
//  UserAPI.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/20.
//

import Foundation
import Alamofire

enum UserAPI: APIEndpoint {

    case login([String: Any])
    case signup([String: Any])
    case bookmark([String: Any])

    var method: HTTPMethod {
        switch self {
        case .login, .signup:
            return .post
        case .bookmark:
            return .patch
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .signup:
            return "/users"
        case .bookmark(let value):
            if let id = value["id"] {
                return "/users/feeds/\(id)/bookmark"
            }
            return ""
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .login(let value), .signup(let value):
            return value
        case .bookmark(let value):
            if let status = value["status"] {
                return ["bookmarkStatus": "\(status)"]
            }
            return [:]
        }
    }
}
