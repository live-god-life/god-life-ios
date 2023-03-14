//
//  UserService.swift
//  LiveGodLife
//
//  Created by wargi on 2022/03/07.
//

import Foundation
import Moya

enum UserService {
    static let ACCESS_TOKEN_KEY = "ACCESS_TOKEN_KEY"
    static let USER_INFO_KEY = "USER_INFO_KEY"
    static var userInfo: UserModel? {
        guard let dictionary = UserDefaults.standard.value(forKey: Self.USER_INFO_KEY) as? [String: Any],
              let data = try? JSONSerialization.data(withJSONObject: dictionary),
              let model = try? JSONDecoder().decode(UserModel.self, from: data) else {
            return nil
        }
        return model
    }
    
    case profileImage
    case terms(Term.TermType)
    case token
    case nickname(String)
    case signup(UserModel)
    case signin(UserModel)
    case withdrawal
    case user
    case heart
}


extension UserService: TargetType{
    public var baseURL: URL {
        return URL(string: "http://101.101.208.221:80")!
    }
    
    var path: String {
        switch self {
        case .profileImage:
            return "/commons/images"
        case .terms(let term):
            return "/commons/terms/\(term.rawValue)"
        case .token:
            return "/tokens"
        case .nickname(let nickname):
            return "/nickname/\(nickname)"
        case .signup:
            return "/users"
        case .signin:
            return "/login"
        case .withdrawal:
            return "/users"
        case .user:
            return "/users"
        case .heart:
            return "/users/hearts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .profileImage, .terms, .token,
                .nickname, .user, .heart:
            return .get
        case .signup, .signin:
            return .post
        case .withdrawal:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .profileImage, .terms, .token,
                .nickname, .withdrawal, .user,
                .heart:
            return .requestPlain
        case .signup(let user):
            return .requestJSONEncodable(user)
        case .signin(let user):
            let parameters = [
                "identifier" : user.identifier ?? "",
                "type" : user.type?.rawValue ?? "",
                "email": user.email ?? ""
            ]
            
            if let data = try? JSONSerialization.data(withJSONObject: parameters) {
                return .requestData(data)
            } else {
                return .requestPlain
            }
            
        }
    }
    
    var headers: [String: String]? {
        let accessToken = UserDefaults.standard.string(forKey: Self.ACCESS_TOKEN_KEY) ?? ""
        var header = ["content-type": "application/json"]
        
        switch self {
        case .profileImage, .token, .withdrawal,
                .user, .heart:
            header.updateValue(accessToken, forKey: "Authorization")
        default:
            break
        }
        
        return header
    }
}
