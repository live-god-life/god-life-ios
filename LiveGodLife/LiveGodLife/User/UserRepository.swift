//
//  UserRepository.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/21.
//

import Foundation
import Combine

struct UserToken: Decodable {
    let authorization: String
}

protocol UserRepository: Requestable {

    func login(endpoint: UserAPI) -> AnyPublisher<APIResponse<UserToken>, APIError>
    func request(endpoint: UserAPI) -> AnyPublisher<UserModel, APIError>
    func updateProfile(endpoint: UserAPI) -> AnyPublisher<UserModel, APIError>
}

struct DefaultUserRepository: UserRepository {

    func login(endpoint: UserAPI) -> AnyPublisher<APIResponse<UserToken>, APIError> {
        var request = endpoint.request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { output in
                guard output.response is HTTPURLResponse else {
                    throw APIError.unknown
                }
                return output.data
            }
            .decode(type: APIResponse<UserToken>.self, decoder: JSONDecoder())
            .mapError { error in
                return APIError.decodingFail(error)
            }
            .eraseToAnyPublisher()
    }

    func request(endpoint: UserAPI) -> AnyPublisher<UserModel, APIError> {
        request(endpoint)
    }

    func updateProfile(endpoint: UserAPI) -> AnyPublisher<UserModel, APIError> {
        request(endpoint)
    }
}
