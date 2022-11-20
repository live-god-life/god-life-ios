//
//  FeedAPI.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/19.
//

import Foundation
import Alamofire

enum FeedAPI: APIEndpoint {

    case feeds
    case feed(Int)

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .feeds:
            return "/feeds"
        case .feed(let id):
            return "/feeds/\(id)"
        }
    }

    var parameters: [String: Any] {
        return [:]
    }
}
