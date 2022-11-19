//
//  User.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/08.
//

import Foundation

struct User: Codable, Hashable {

    // TODO: User 모델의 분리?
    let nickname: String
    let type: LoginType?
    let identifier: String?
    let email: String?
    let image: String?
}
