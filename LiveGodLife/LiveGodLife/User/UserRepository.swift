//
//  UserRepository.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/21.
//

import Foundation
import Combine

protocol UserRepository: Requestable {

    func request(endpoint: UserAPI) -> AnyPublisher<UserModel, APIError>
    func updateProfile(endpoint: UserAPI) -> AnyPublisher<UserModel, APIError>
}

struct DefaultUserRepository: UserRepository {

    func request(endpoint: UserAPI) -> AnyPublisher<UserModel, APIError> {
        request(endpoint)
    }

    func updateProfile(endpoint: UserAPI) -> AnyPublisher<UserModel, APIError> {
        request(endpoint)
    }
}
