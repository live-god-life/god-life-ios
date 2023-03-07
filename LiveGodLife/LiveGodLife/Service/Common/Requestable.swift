//
//  Requestable.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/08.
//

import Foundation
import Combine

protocol Requestable {
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIError>
}

enum APIError: Error {
    case httpError // http 응답 200대가 아님
    case decoding
    case unknown
    case error(Error)
}

extension Requestable {

    // 일반 조회 API 요청
    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIError> {
        let accessToken = UserDefaults.standard.string(forKey: UserService.ACCESS_TOKEN_KEY) ?? ""
        
        var request = endpoint.request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryFilter {
                guard let response = $0.response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    throw APIError.httpError
                }
                return true
            }
            .map(\.data)
            .decode(type: APIResponse<T>.self, decoder: JSONDecoder())
            .compactMap { response in
                return response.data
            }
            .mapError { error in
                return APIError.error(error)
            }
            .eraseToAnyPublisher()
    }
}
