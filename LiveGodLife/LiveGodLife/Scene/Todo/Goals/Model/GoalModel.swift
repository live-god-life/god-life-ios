//
//  GoalModel.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/30.
//

import Foundation

protocol GoalProtocol: Decodable {
    var goalId: Int? { get set }
    var category: String? { get set }
    var title: String? { get set }
    var startDate: String? { get set }
    var endDate: String? { get set }
    var totalMindsetCount: Int? { get set }
    var totalTodoCount: Int? { get set }
    var completedTodoCount: Int? { get set }
    var totalTodoTaskScheduleCount: Int? { get set }
}

struct GoalModel: Hashable, GoalProtocol {
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
