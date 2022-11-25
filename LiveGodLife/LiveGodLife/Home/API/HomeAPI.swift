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
    case category

    var method: HTTPMethod {
        switch self {
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
        case .category:
            return "/commons/categories"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .todos(let value):
            return value
        default:
            return [:]
        }
    }
}
