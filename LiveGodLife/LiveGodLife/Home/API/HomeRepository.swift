//
//  HomeRepository.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/19.
//

import Foundation
import Combine

protocol HomeRepository: Requestable {

    func requestGoals(endpoint: HomeAPI) -> AnyPublisher<[Goal], APIError>
    func requestTodos(endpoint: HomeAPI) -> AnyPublisher<[Todo], APIError>
}

struct DefaultHomeRepository: HomeRepository {

    func requestGoals(endpoint: HomeAPI) -> AnyPublisher<[Goal], APIError> {
        return request(endpoint)
    }
    func requestTodos(endpoint: HomeAPI) -> AnyPublisher<[Todo], APIError> {
        return request(endpoint)
    }
}
