//
//  Endpoint.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/08.
//

import Foundation
import Alamofire

protocol APIEndpoint {

    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any] { get }
}

extension APIEndpoint {

    var url: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "49.50.167.208"
        components.port = 8000
        components.path = path

        var queryItems: [URLQueryItem] = []
        parameters.forEach { (key, value) in
            let query = URLQueryItem(name: key, value: value as? String)
            queryItems.append(query)
        }
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }

    var request: URLRequest {
        var request = URLRequest(url: url)
        if method == .post {
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        }
        return request
    }
}
