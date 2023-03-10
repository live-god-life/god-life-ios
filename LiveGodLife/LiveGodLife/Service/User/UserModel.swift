//
//  User.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/08.
//

import Foundation

struct UserModel: Codable, Hashable {

    // TODO: User 모델의 분리?
    var nickname: String
    let type: LoginType?
    let identifier: String?
    var email: String?
    var image: String?
    var marketingYn: String?

    init(nickname: String, type: LoginType?, identifier: String?, email: String?, image: String?) {
        self.nickname = nickname
        self.type = type
        self.identifier = identifier
        self.email = email
        self.image = image
    }

    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
