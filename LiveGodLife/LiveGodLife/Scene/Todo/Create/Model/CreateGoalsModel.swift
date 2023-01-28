//
//  CreateGoalsModel.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/12/21.
//

import Foundation

enum GoalType: Int {
    case task
    case folder
    
    var name: String {
        switch self {
        case .folder:
            return "FOLDER"
        case .task:
            return "TASK"
        }
    }
}

struct DisplayTodo: Codable {
    var type: String
    var index: Int
    var taskModel: ChildTodo?
    var folderModel: TodosModel?
}

struct TodosModel: Codable {
    var title: String
    var type: String
    var depth: Int
    var orderNumber: Int
    var startDate: String?
    var endDate: String?
    var repetitionType: String?
    var repetitionParams: [String]?
    var notification: String?
    var todos: [ChildTodo]?
}

struct ChildTodo: Codable {
    var title: String
    var type: String
    var depth: Int
    var orderNumber: Int
    var startDate: String
    var endDate: String
    var repetitionType: String
    var repetitionParams: [String]?
    var notification: String?
}

struct CreateGoalsModel: Codable {
    var title: String
    var categoryCode: String
    var mindsets: [GoalsMindset]
    var todos: [TodosModel]
}

struct GoalsMindset: Codable {
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case content
    }
}
