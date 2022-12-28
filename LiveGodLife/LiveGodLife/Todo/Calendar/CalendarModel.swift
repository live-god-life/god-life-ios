//
//  CalenderModel.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/14.
//

import Foundation

struct MainCalendarModel:Codable {
    var title:String
    var goalId:Int
    var todoSchedules:[SubCalendarModel]
    
    enum Codingkeys: Int,CodingKey{
        case title
        case goalId
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.goalId = try container.decode(Int.self, forKey: .goalId)
        self.todoSchedules = try container.decode([SubCalendarModel].self, forKey: .todoSchedules)
    }
}
struct SubCalendarModel:Codable {
    var title:String
    var completionStatus: Bool?
    var taskType: String
    var repetitionType: String
    var repetitionParams: [String]?
    var totalTodoTaskScheduleCount: Int
    var completedTodoTaskScheduleCount: Int
    var todoDay: Int
    
    enum Codingkeys: Int,CodingKey{
        case title
        case action
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.completionStatus = try container.decodeIfPresent(Bool.self, forKey: .completionStatus)
        self.taskType = try container.decode(String.self, forKey: .taskType)
        self.repetitionType = try container.decode(String.self, forKey: .repetitionType)
        self.repetitionParams = try container.decodeIfPresent([String].self, forKey: .repetitionParams)
        self.totalTodoTaskScheduleCount = try container.decode(Int.self, forKey: .totalTodoTaskScheduleCount)
        self.completedTodoTaskScheduleCount = try container.decode(Int.self, forKey: .completedTodoTaskScheduleCount)
        self.todoDay = try container.decode(Int.self, forKey: .todoDay)
    }
}
