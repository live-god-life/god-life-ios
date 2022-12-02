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
    var rawValue:String
    var todoSchedules:[SubCalendarModel]
    
    enum Codingkeys: Int,CodingKey{
        case title
        case goalId
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
}
