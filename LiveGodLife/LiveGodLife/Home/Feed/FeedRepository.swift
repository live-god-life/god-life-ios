//
//  FeedRepository.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/13.
//

import Foundation
import Combine

protocol FeedRepository: Requestable {

    func requestFeeds(endpoint: FeedAPI) -> AnyPublisher<[Feed], APIError>
    func requestFeed(endpoint: FeedAPI) -> AnyPublisher<Feed, APIError>
}

struct DefaultFeedRepository: FeedRepository {

    func requestFeeds(endpoint: FeedAPI) -> AnyPublisher<[Feed], APIError> {
        return request(endpoint)
    }

    func requestFeed(endpoint: FeedAPI) -> AnyPublisher<Feed, APIError> {
        return request(endpoint)
    }
}
