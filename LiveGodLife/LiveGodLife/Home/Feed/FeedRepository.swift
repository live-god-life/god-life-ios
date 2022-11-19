//
//  FeedRepository.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/13.
//

import Foundation
import Combine

protocol FeedRepository: Requestable {

    func request(endpoint: FeedAPI) -> AnyPublisher<[Feed], APIError>
}

struct DefaultFeedRepository: FeedRepository {

    func request(endpoint: FeedAPI) -> AnyPublisher<[Feed], APIError> {
        return request(endpoint)
    }
}
