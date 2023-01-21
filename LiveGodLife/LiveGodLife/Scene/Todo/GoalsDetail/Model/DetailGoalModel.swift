//
//  DetailGoalModel.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/26.
//

import Foundation

struct DetailGoalModel: GoalProtocol {
    var goalId: Int?
    var category: String?
    var title: String?
    var startDate: String?
    var endDate: String?
    var totalMindsetCount: Int?
    var totalTodoCount: Int?
    var completedTodoCount: Int?
    var totalTodoTaskScheduleCount: Int?
    var completedTodoTaskScheduleCount: Int?
    var mindsets: [MindSetModel]?
    var todos: [TodoModel]?
}

struct TodoModel: Decodable {
    let todoId: Int
    let parentTodoId: Int?
    let type: String?
    let title: String?
    let depth: Int?
    let orderNumber: Int?
    let startDate: String?
    let endDate: String?
    let repetitionType: String?
    let repetitionParams: [String]?
    let notification: String?
    let totalTodoTaskScheduleCount: Int?
    let completedTodoTaskScheduleCount: Int?
    let childTodos: [TodoModel]?
}
