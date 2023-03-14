//
//  UserRepository.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/21.
//

import Foundation
import Combine

protocol UserRepository: Requestable {

    func login(endpoint: UserAPI) -> AnyPublisher<APIResponse<UserToken>, APIError>
    func signup(endpoint: UserAPI) -> AnyPublisher<UserToken, APIError>
    func validateNickname(endpoint: UserAPI) -> AnyPublisher<Empty, APIError>
    func fetchProfile(endpoint: UserAPI) -> AnyPublisher<UserModel, APIError>
    func updateProfile(endpoint: UserAPI) -> AnyPublisher<Empty, APIError>
}

struct DefaultUserRepository: UserRepository {

    func login(endpoint: UserAPI) -> AnyPublisher<APIResponse<UserToken>, APIError> {
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
            .decode(type: APIResponse<UserToken>.self, decoder: JSONDecoder())
            .mapError { error in
                return APIError.error(error)
            }
            .eraseToAnyPublisher()
    }

    func signup(endpoint: UserAPI) -> AnyPublisher<UserToken, APIError> {
        request(endpoint)
    }

    // 닉네임 중복체크
    func validateNickname(endpoint: UserAPI) -> AnyPublisher<Empty, APIError> {
        request(endpoint)
    }

    func fetchProfile(endpoint: UserAPI) -> AnyPublisher<UserModel, APIError> {
        request(endpoint)
    }

    func updateProfile(endpoint: UserAPI) -> AnyPublisher<Empty, APIError> {
        request(endpoint)
    }
}
