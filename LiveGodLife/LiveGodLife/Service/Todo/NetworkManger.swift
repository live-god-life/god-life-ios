//
//  NetworkManger.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/12/14.
//

import Foundation
import Alamofire
import Moya

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    private var plugin = MoyaPlugin()
    lazy var provider = MoyaProvider<NetworkService>(plugins: [plugin])
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
    case updateGoals(Int, Data)
    case deleteGoals(Dictionary<String,Any>)
    case detailTodo(Dictionary<String,Any>)
    case detailTodos(Dictionary<String,Any>)
    case deleteTodo(Dictionary<String,Any>)
}
extension NetworkService: TargetType {
    public var baseURL: URL {
        // GeneralAPI 라는 구조체 파일에 서버 도메인이나 토큰 값을 적어두고 불러왔습니다.
        return URL(string: "http://101.101.208.221:80")!
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
        case .addGoals:
            return "/goals"
        case .updateGoals(let id, _):
            return "/goals/\(id)"
        case .deleteGoals(let parameters):
            let goalId = parameters["goalId"] as? Int ?? 1
            return "/goals/\(goalId)"
        case .detailTodo(let parameters):
            let todoId = parameters["todoId"] as? Int ?? 1
            return "/goals/todos/\(todoId)"
        case .detailTodos(let parameters):
            let todoId = parameters["todoId"] as? Int ?? 1
            return "/goals/todos/\(todoId)/todoSchedules"
        case .deleteTodo(let parameters):
            let todoId = parameters["todoId"] as? Int ?? 1
            return "/goals/todos/\(todoId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .nickname, .otherDetail, .day,
                .month, .mindsets, .goals,
                .deatilGoals, .detailTodo, .detailTodos:
            return .get
        case .addGoals, .join, .login:
            return .post
        case .updateGoals:
            return .put
        case .status:
            return .patch
        case .deleteGoals, .deleteTodo:
            return .delete
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
        case .join(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .month(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .day(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .status(_, let parameters):
            let data = try! JSONSerialization.data(withJSONObject: parameters)
            return .requestData(data)
        case .mindsets(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .goals(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .addGoals(let model):
            return .requestData(model)
        case .updateGoals(_, let model):
            return .requestData(model)
        case .deatilGoals:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .deleteGoals(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .login(let parameter):
            let data = try! JSONSerialization.data(withJSONObject: parameter)
            return .requestData(data)
        case .detailTodo(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .detailTodos(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .deleteTodo(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        let accessToken = UserDefaults.standard.string(forKey: UserService.ACCESS_TOKEN_KEY) ?? ""
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "Authorization": accessToken] // GeneralAPI.token
        }
    }
}

