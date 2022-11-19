//
//  Feed.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/31.
//

import Foundation

struct Feed: Hashable, Decodable {

    let id: Int
    let title: String
    let user: User
    let image: String
    let isBookmark: Bool

    enum CodingKeys: String, CodingKey {
        case id = "feedId"
        case isBookmark = "bookMarkStatus"
        case title, user, image
    }

    static func == (lhs: Feed, rhs: Feed) -> Bool {
        return lhs.id == rhs.id
    }
}
