//
//  MyPageAPI.swift
//  LiveGodLife
//
//  Created by Ador on 2022/12/01.
//

import Foundation
import Alamofire

enum MyPageAPI: APIEndpoint {
    case images

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .images:
            return "/commons/images"
        }
    }

    var parameters: [String: Any] {
        switch self {
        default:
            return [:]
        }
    }
}
