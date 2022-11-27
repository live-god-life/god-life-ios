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

//    case apiError
//    case unauthorized
//    case badRequest
//    case serverError
//    case noResponse
    case decodingFail(Error)
    case unknown
}

extension Requestable {

    func request<T: Decodable>(_ endpoint: APIEndpoint) -> AnyPublisher<T, APIError> {

        var request = endpoint.request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer test", forHTTPHeaderField: "Authorization")

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw APIError.unknown
                }
                return output.data
            }
            .decode(type: APIResponse<T>.self, decoder: JSONDecoder())
            .compactMap { response in
                return response.data
            }
            .mapError { error in
                return APIError.decodingFail(error)
            }
            .eraseToAnyPublisher()
    }
}
