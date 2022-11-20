//
//  UserRepository.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/21.
//

import Foundation
import Combine

protocol UserRepository: Requestable {

    func request(endpoint: UserAPI) -> AnyPublisher<User, APIError>
    func updateProfile(endpoint: UserAPI) -> AnyPublisher<User, APIError>
}

struct DefaultUserRepository: UserRepository {

    func request(endpoint: UserAPI) -> AnyPublisher<User, APIError> {
        request(endpoint)
    }

    func updateProfile(endpoint: UserAPI) -> AnyPublisher<User, APIError> {
        request(endpoint)
    }
}
