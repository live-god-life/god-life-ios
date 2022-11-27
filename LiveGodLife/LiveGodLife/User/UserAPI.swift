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
    case user
    case bookmark([String: Any])
    case profileUpdate([String: Any])
    case logout

    var method: HTTPMethod {
        switch self {
        case .login, .signup, .logout:
            return .post
        case .user:
            return .get
        case .bookmark, .profileUpdate:
            return .patch
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .signup, .user:
            return "/users"
        case .bookmark(let value):
            if let id = value["id"] {
                return "/users/feeds/\(id)/bookmark"
            }
            return ""
        case .profileUpdate:
            return "/users"
        case .logout:
            return "/logout"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .login(let value), .signup(let value), .profileUpdate(let value):
            return value
        case .bookmark(let value):
            if let status = value["status"] {
                return ["bookmarkStatus": "\(status)"]
            }
            return [:]
        default:
            return [:]
        }
    }
}
