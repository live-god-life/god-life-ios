//
//  CalenderModel.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/14.
//

import Foundation

struct DayModel: Decodable {
    var date: String?
    var todoCount: Int?
    var dDayCount: Int?
}

struct MainCalendarModel: Decodable, Hashable {
    var title: String?
    var goalId: Int?
    var todoSchedules: [SubCalendarModel]?
    
    enum Codingkeys: Int,CodingKey{
        case title
        case goalId
    }
}

struct SubCalendarModel: Decodable, Hashable {
    var todoScheduleId: Int?
    var todoId: Int?
    var title: String?
    var completionStatus: Bool?
    var taskType: String?
    var repetitionType: String?
    var repetitionParams: [String]?
    var totalTodoTaskScheduleCount: Int?
    var completedTodoTaskScheduleCount: Int?
    var todoDay: Int?
    
    enum Codingkeys: Int,CodingKey{
        case title
        case action
    }
}
