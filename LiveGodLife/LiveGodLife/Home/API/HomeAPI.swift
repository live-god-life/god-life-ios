//
//  HomeAPI.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/13.
//

import Foundation
import Alamofire

enum HomeAPI: APIEndpoint {

    case mindsets
    case todos([String: Any])
    case todoDetail(String)
    case todoSchedules(String, [String: Any])
    case category
    case completeTodo(Int)

    var method: HTTPMethod {
        switch self {
        case .completeTodo:
            return .patch
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .mindsets:
            return "/goals/mindsets"
        case .todos:
            return "/goals/todos"
        case .todoDetail(let id):
            return "/goals/todos/\(id)"
        case .todoSchedules(let id, _):
            return "/goals/todos/\(id)/todoSchedules"
        case .category:
            return "/commons/categories"
        case .completeTodo(let id):
            return "/goals/todoSchedules/\(id)"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .todos(let value):
            return value
        case .todoSchedules(_, let param):
            return param
        case .completeTodo:
            return ["completionStatus": "true"]
        default:
            return [:]
        }
    }
}
