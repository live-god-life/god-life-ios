//
//  Feed.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/31.
//

import Foundation

struct Feed: Hashable, Decodable {

    struct Content: Hashable, Decodable {
        let title: String
        let content: String
    }

    struct Mindset: Hashable, Decodable {
        let id: Int
        let content: String
    }

    struct FeedTodo: Hashable, Decodable {
        let id: Int
        let title: String
        let childs: [FeedTodo]?

        enum CodingKeys: String, CodingKey {
            case id = "todoId"
            case childs = "childTodos"
            case title
        }
    }

    let id: Int
    let title: String
    let user: User
    let image: String
    let isBookmark: Bool
    // 피드 상세에 사용되는 데이터
    let todoCount: Int
    let todoScheduleDay: Int
    let category: String // Type
    let contents: [Content]
    let mindsets: [Mindset]
    let todos: [FeedTodo]

    enum CodingKeys: String, CodingKey {
        case id = "feedId"
        case isBookmark = "bookMarkStatus"
        case title, user, image, todoCount, todoScheduleDay, category, contents, mindsets, todos
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        user = try container.decode(User.self, forKey: .user)
        image = try container.decode(String.self, forKey: .image)
        todoCount = try container.decodeIfPresent(Int.self, forKey: .todoCount) ?? 0
        todoScheduleDay = try container.decodeIfPresent(Int.self, forKey: .todoScheduleDay) ?? 0
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        isBookmark = try container.decode(Bool.self, forKey: .isBookmark)
        contents = try container.decodeIfPresent([Content].self, forKey: .contents) ?? []
        mindsets = try container.decodeIfPresent([Mindset].self, forKey: .mindsets) ?? []
        todos = try container.decodeIfPresent([FeedTodo].self, forKey: .todos) ?? []
    }

    static func == (lhs: Feed, rhs: Feed) -> Bool {
        return lhs.id == rhs.id
    }
}
