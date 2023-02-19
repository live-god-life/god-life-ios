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
    case month(Dictionary<String,Any>)
    case day(Dictionary<String,Any>)
    case status(Int, Dictionary<String,Any>)
    case mindsets(Dictionary<String,Any>)
    case goals(Dictionary<String,Any>)
    case deatilGoals(Int)
    case addGoals(Data)
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
        case .month:
            return "/goals/todos/counts"
        case .day:
            return "/goals/todos"
        case .status(let id, _):
            return "/goals/todoSchedules/\(id)"
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
        case .nickname, .otherDetail, .day, .month,
             .mindsets, .goals, .deatilGoals:
            return .get
        case .status:
            return .patch
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
        case .month(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        case .day(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        case .status(_, let parameter):
            let data = try! JSONSerialization.data(withJSONObject: parameter)
            return .requestData(data)
        case .mindsets(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        case .goals(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        case .addGoals(let model):
            return .requestData(model)
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

