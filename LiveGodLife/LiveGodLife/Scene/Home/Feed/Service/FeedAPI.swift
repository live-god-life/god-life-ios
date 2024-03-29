//
//  FeedAPI.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/19.
//

import Foundation
import Alamofire

enum FeedAPI: APIEndpoint {
    case feeds([String: String]? = nil)
    case feed(Int)
    case heartFeeds

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .feeds:
            return "/feeds"
        case .feed(let id):
            return "/feeds/\(id)"
        case .heartFeeds:
            return "/users/hearts"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .feeds(let value):
            return value ?? [:]
        default:
            return [:]
        }
    }
}
