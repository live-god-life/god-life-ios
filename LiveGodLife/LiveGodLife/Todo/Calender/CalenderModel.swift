//
//  CalenderModel.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/14.
//

import Foundation

//"data": [
//        {
//            "goalId": 1,
//            "title": "이직하기",
//            "todoSchedules": [
//                {
//                    "todoScheduleId": 43,
//                    "todoId": 2,
//                    "title": "컨셉잡기",
//                    "completionStatus": false,
//                    "taskType": "Todo",
//                    "repetitionType": "DAY",
//                    "repetitionParams": null,
//                    "totalTodoTaskScheduleCount": 91,
//                    "completedTodoTaskScheduleCount": 0,
//                    "todoDay": -48
//                }
//            ]
//        },

//
/// samplCode Data
/// 해당 샘플 데이터는 삭제예정
/*
{
            "goalId": 2,
            "title": "이직하기",
            "todoSchedules": [
                {
                    "todoScheduleId": 157,
                    "todoId": 10,
                    "title": "컨셉잡기",
                    "completionStatus": false,
                    "taskType": "Todo",
                    "repetitionType": "DAY",
                    "repetitionParams": null,
                    "totalTodoTaskScheduleCount": 91,
                    "completedTodoTaskScheduleCount": 0,
                    "todoDay": -48
                },
                {
                    "todoScheduleId": 224,
                    "todoId": 11,
                    "title": "스케치",
                    "completionStatus": false,
                    "taskType": "Todo",
                    "repetitionType": "WEEK",
                    "repetitionParams": [
                        "월",
                        "목",
                        "토"
                    ],
                    "totalTodoTaskScheduleCount": 39,
                    "completedTodoTaskScheduleCount": 0,
                    "todoDay": -48
                }
            ]
        }
*/

struct MainGoals:Codable {
    var title:String
    var goalId:Int
    var rawValue:String
    var todoSchedules:[SubGoals]
    enum Codingkeys: Int,CodingKey{
        case title
        case goalId
    }
}
struct SubGoals:Codable {
    var title:String
    var todoSchedules: String
    var completionStatus: Bool
    var taskType: String
    var repetitionType: String
    var repetitionParams: String
    var totalTodoTaskScheduleCount: Int
    var completedTodoTaskScheduleCount: 0
    var todoDay: Int
    
    enum Codingkeys: Int,CodingKey{
        case title
        case action
    }
}
