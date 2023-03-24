//
//  TodoScheduleViewModel.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/31.
//

import Foundation

struct TodoScheduleViewModel: Decodable {
    let todoScheduleID: Int
    let title: String
    let scheduleDate: String
    let dayOfWeek: String
    var completionStatus: Bool

    enum CodingKeys: String, CodingKey {
        case todoScheduleID = "todoScheduleId"
        case title, scheduleDate, dayOfWeek, completionStatus
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        todoScheduleID = try container.decode(Int.self, forKey: .todoScheduleID)
        title = try container.decode(String.self, forKey: .title)
        scheduleDate = try container.decode(String.self, forKey: .scheduleDate)
        dayOfWeek = try container.decode(String.self, forKey: .dayOfWeek)
        completionStatus = try container.decode(Bool.self, forKey: .completionStatus)
    }
}
