//
//  Endpoint.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/08.
//

import Foundation
import Alamofire

enum Endpoint {

    typealias Data = [String: String]

    case login(Data)
    case signup(Data)

    var method: HTTPMethod {
        switch self {
        case .login, .signup:
            return .post
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .signup:
            return "/users"
        }
    }

    var data: Data {
        switch self {
        case .login(let data), .signup(let data):
            return data
        }
    }

    var url: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "49.50.167.208"
        components.port = 8000
        components.path = path

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
}
