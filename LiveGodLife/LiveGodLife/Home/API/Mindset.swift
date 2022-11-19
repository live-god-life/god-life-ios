//
//  Mindset.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/19.
//

import Foundation

struct Mindset: Decodable {

    let id: Int
    let content: String

    enum CodingKeys: String, CodingKey {
        case id = "mindsetId"
        case content
    }
}

class Goal: Decodable {

    let id: Int
    let title: String
    let mindsets: [Mindset]

    enum CodingKeys: String, CodingKey {
        case id = "goalId"
        case title, mindsets
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        mindsets = try container.decodeIfPresent([Mindset].self, forKey: .mindsets) ?? []
    }
}

class Todo: Goal {

    struct Schedule: Decodable {

        let scheduleID: Int
        let id: Int
        let title: String
        let isCompletion: Bool
//        let taskType: String // Type
        let repetitionType: String // Type "DAY" "WEEK"
        let repetitions: [String]
        // 투두의 프로그래스바를 그리기 위한 값
        let totalCount: Int
        let completedCount: Int
        let dDay: Int

        enum CodingKeys: String, CodingKey {
            case title, repetitionType
            case scheduleID = "todoScheduleId"
            case id = "todoId"
            case isCompletion = "completionStatus"
            case repetitions = "repetitionParams"
            case totalCount = "totalTodoTaskScheduleCount"
            case completedCount = "completedTodoTaskScheduleCount"
            case dDay = "todoDay"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            scheduleID = try container.decode(Int.self, forKey: .scheduleID)
            id = try container.decode(Int.self, forKey: .id)
            title = try container.decode(String.self, forKey: .title)
            isCompletion = try container.decode(Bool.self, forKey: .isCompletion)
            repetitionType = try container.decode(String.self, forKey: .repetitionType)
            repetitions = try container.decodeIfPresent([String].self, forKey: .repetitions) ?? []
            totalCount = try container.decode(Int.self, forKey: .totalCount)
            completedCount = try container.decode(Int.self, forKey: .completedCount)
            dDay = try container.decode(Int.self, forKey: .dDay)
        }
    }

    let schedules: [Schedule]

    enum CodingKeys: String, CodingKey {
        case schedules = "todoSchedules"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        schedules = try container.decodeIfPresent([Schedule].self, forKey: .schedules) ?? []
        try super.init(from: decoder)
    }
}
