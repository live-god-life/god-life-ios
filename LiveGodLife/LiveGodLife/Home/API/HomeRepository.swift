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
    func requestCategory(endpoint: HomeAPI) -> AnyPublisher<[Category], APIError>
    func updateTodoStatus(endpoint: HomeAPI) -> AnyPublisher<String?, APIError>
}

struct DefaultHomeRepository: HomeRepository {

    func requestGoals(endpoint: HomeAPI) -> AnyPublisher<[Goal], APIError> {
        return request(endpoint)
    }

    func requestTodos(endpoint: HomeAPI) -> AnyPublisher<[Todo], APIError> {
        return request(endpoint)
    }

    func requestCategory(endpoint: HomeAPI) -> AnyPublisher<[Category], APIError> {
        return request(endpoint)
    }

    // Empty 사용할 수 있는지 체크
    func updateTodoStatus(endpoint: HomeAPI) -> AnyPublisher<String?, APIError> {
        return request(endpoint)
    }
}
