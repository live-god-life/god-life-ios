//
//  GoalModel.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/30.
//

import Foundation

struct GoalModel: Decodable, Hashable {
    var goalId: Int?
    var category: String?
    var title: String?
    var completionStatus: Bool?
    var startDate: String?
    var endDate: String?
    var totalMindsetCount: Int?
    var totalTodoCount: Int?
    var completedTodoCount: Int?
    var totalTodoTaskScheduleCount: Int?
    
    enum Codingkeys: Int,CodingKey {
        case title
        case goalId
    }
}
