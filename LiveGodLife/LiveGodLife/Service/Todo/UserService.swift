//
//  LGLService.swift
//  LiveGodLife
//
//  Created by wargi on 2022/03/07.
//

import Foundation
import Moya

enum LGLService {
    case profileImage
    case terms(String)
    case token
    case nickname(String)
    case signup(UserModel)
    case signin(Dictionary<String, Any>)
    case signout
    case withdrawal
}


extension LGLService: TargetType{
    public var baseURL: URL {
        return URL(string: "http://101.101.208.221:80")!
    }

    var path: String {
        switch self {
        case .profileImage:
            return "/commons/images"
        case .terms(let type):
            return "/commons/terms/\(type)"
        case .token:
            return "/tokens"
        case .nickname(let nickname):
            return "/nickname/\(nickname)"
        case .signup:
            return "/users"
        case .signin:
            return "/login"
        case .signout:
            return "/logout"
        case .withdrawal:
            return "/users"
        }
    }

    var method: Moya.Method {
        switch self {
        case .profileImage, .terms, .token, .nickname:
            return .get
        case .signup, .signin, .signout:
            return .post
        case .withdrawal:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .profileImage, .terms, .token,
             .nickname, .signout, .withdrawal:
            return .requestPlain
        case .signup(let user):
            return .requestJSONEncodable(user)
        case .signin(let parameters):
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        var header = ["content-type": "application/json"]
        
        switch self {
        case .profileImage, .token, .signout,
             .withdrawal:
            header.updateValue("Bearer \(accessToken)", forKey: "Authorization")
        default:
            break
        }
        
        return header
    }
}
