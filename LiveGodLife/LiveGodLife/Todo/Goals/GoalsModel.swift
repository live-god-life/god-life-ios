//
//  GoalsModel.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/30.
//

import Foundation
//"data": [
//    {
//      "goalId": 1,
//      "category": "CAREER",
//      "title": "이직하기",
//      "completionStatus": false,
//      "startDate": "20221001",
//      "endDate": "20221231",
//      "totalMindsetCount": 1,
//      "totalTodoCount": 6,
//      "completedTodoCount": 0,
//      "totalTodoTaskScheduleCount": 61,
//      "completedTodoTaskScheduleCount": 0
//    }
//  ]

struct GoalsModel: Codable {
    var goalId: Int
    var category: String
    var title: String
    var completionStatus: Bool
    var startDate: String
    var endDate: String
    var totalMindsetCount: Int
    var totalTodoCount: Int
    var completedTodoCount: Int
    var totalTodoTaskScheduleCount: Int
    enum Codingkeys: Int,CodingKey{
        case title
        case goalId
    }
}
