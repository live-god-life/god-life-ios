//
//  TaskViewModel.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/07.
//

import Foundation

// TODO: 모델/뷰모델 분리
struct TaskViewModel: Decodable {

    var todoId: Int = 0
    var title: String = ""
    var type: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var repetitionType: String = ""
//  var repetitionParams
    var notification: String = ""
    var totalTodoTaskScheduleCount: Int = 0
    var completedTodoTaskScheduleCount: Int = 0
}
