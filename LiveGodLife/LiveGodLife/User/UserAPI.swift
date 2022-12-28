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
    case signup(UserModel)
    case user
    case bookmark([String: Any])
    case nickname(String)
    case profileUpdate([String: Any])
    case logout

    var method: HTTPMethod {
        switch self {
        case .login, .signup, .logout:
            return .post
        case .bookmark, .profileUpdate:
            return .patch
        default:
            return .get
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
        case .nickname(let value):
            return "/nickname/\(value)"
        case .profileUpdate:
            return "/users"
        case .logout:
            return "/logout"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .login(let value), .profileUpdate(let value):
            return value
        case .signup(let user):
            return user.toDictionary ?? [:]
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
