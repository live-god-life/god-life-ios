//
//  MyPageRepository.swift
//  LiveGodLife
//
//  Created by Ador on 2022/12/01.
//

import Foundation
import Combine

protocol MyPageRepository: Requestable {

    func requestImages(endpoint: MyPageAPI) -> AnyPublisher<[String], APIError>
}

struct DefaultMyPageRepository: MyPageRepository {

    func requestImages(endpoint: MyPageAPI) -> AnyPublisher<[String], APIError> {
        request(endpoint)
    }
}
