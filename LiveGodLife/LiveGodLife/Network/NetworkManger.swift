//
//  NetworkManger.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/12/14.
//

import Foundation
import Alamofire
import Moya
import SwiftyJSON

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    let provider = MoyaProvider<NetworkService>()
}

enum NetworkService {
    case nickname
    case join(Dictionary<String,Any>)
    case otherDetail(String, Int)
    case login(Dictionary<String,Any>)
    case calendar(Dictionary<String,Any>)
    case todos(Dictionary<String,Any>)
    case mindsets(Dictionary<String,Any>)
    case goals(Dictionary<String,Any>)
    case deatilGoals(Int)
    case addGoals(Dictionary<String,Any>)
}
extension NetworkService: TargetType {
    public var baseURL: URL {
        // GeneralAPI 라는 구조체 파일에 서버 도메인이나 토큰 값을 적어두고 불러왔습니다.
        return URL(string:  "http://101.101.208.221:80")!
    }
    var path: String {
        switch self {
        case .nickname:
            return "/nickname/hun"
        case .otherDetail(let userID, let index):
            return "/other/detail/\(userID)/\(index)"
        case .join:
            return "/users"
        case .login:
            return "/login"
        case .calendar:
            return "/goals/todos/counts"
        case .todos:
            return "/goals/todos"
        case .mindsets:
            return "/goals/mindsets"
        case .goals:
            return "/goals"
        case .deatilGoals(let goalsID):
            return "/goals/\(goalsID)"
        case .addGoals(_):
            return "/goals"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .nickname, .otherDetail, .todos, .calendar,
             .mindsets, .goals, .deatilGoals:
            return .get
        case .addGoals, .join, .login:
            return .post
        }
    }
    
    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .nickname:
            return .requestPlain
        case .otherDetail(_, _):
            return .requestPlain
        case .join(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        case .calendar(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        case .todos(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        case .mindsets(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        case .goals(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        case .addGoals(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        case .deatilGoals:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .login(let parameter):
            let data = try! JSONSerialization.data(withJSONObject: parameter)
            return .requestData(data)
        }
    }
    
    var headers: [String: String]? {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer test"] // GeneralAPI.token
        }
    }
}

