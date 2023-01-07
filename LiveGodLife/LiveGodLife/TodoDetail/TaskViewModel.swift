//
//  TaskViewModel.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/07.
//

import Foundation

enum TaskRepetitionType: String, Decodable {
    case day = "DAY"
    case week = "WEEK"
    case month = "MONTH"
    case none = "NONE" // d-day
}

// TODO: 모델/뷰모델 분리
struct TaskViewModel: Decodable {

    let todoID: Int
    let title: String
    let type: String
    let startDate: String
    let endDate: String
    let repetitionType: TaskRepetitionType
    let repetitionParams: [String]
    let notification: String
    let totalCount: Int
    let completedCount: Int

    enum CodingKeys: String, CodingKey {
        case todoID = "todoId"
        case totalCount = "totalTodoTaskScheduleCount"
        case completedCount = "completedTodoTaskScheduleCount"
        case title, type, startDate, endDate, repetitionType, repetitionParams, notification
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        todoID = try container.decode(Int.self, forKey: .todoID)
        title = try container.decode(String.self, forKey: .title)
        type = try container.decode(String.self, forKey: .type)
        startDate = try container.decode(String.self, forKey: .startDate)
        endDate = try container.decode(String.self, forKey: .endDate)
        repetitionType = try container.decodeIfPresent(TaskRepetitionType.self, forKey: .repetitionType) ?? .none
        repetitionParams = try container.decodeIfPresent([String].self, forKey: .repetitionParams) ?? []
        notification = try container.decode(String.self, forKey: .notification)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        completedCount = try container.decode(Int.self, forKey: .completedCount)
    }
}
