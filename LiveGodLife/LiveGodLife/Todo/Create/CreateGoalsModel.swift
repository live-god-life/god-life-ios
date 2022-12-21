//
//  CreateGoalsModel.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/12/21.
//

import Foundation

struct TodosModel: Codable {
    let title: String
    let type: String
    let deoth: Int
    let orderNumber: Int
    var todos: [ChildTodo]?
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.deoth, forKey: .deoth)
        try container.encode(self.orderNumber, forKey: .orderNumber)
        try container.encodeIfPresent(self.todos, forKey: .todos)
    }
}
struct ChildTodo: Codable {
    let title: String
    let type: String
    let deoth: Int
    let orderNumber: Int
    var startDate: String
    var endDate: String
    var repetitionType: String
    var repetitionParams: [String]?
    var notification: String?
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.deoth, forKey: .deoth)
        try container.encode(self.orderNumber, forKey: .orderNumber)
        try container.encode(self.startDate, forKey: .startDate)
        try container.encode(self.endDate, forKey: .endDate)
        try container.encode(self.repetitionType, forKey: .repetitionType)
        try container.encodeIfPresent(self.repetitionParams, forKey: .repetitionParams)
        try container.encodeIfPresent(self.notification, forKey: .notification)
    }
}
struct CreateGoalsModel: Codable {
    let title: String
    let categoryCode: String
    var mindsets: [SubMindSetModel]
    var todos: [TodosModel]?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.categoryCode, forKey: .categoryCode)
        try container.encode(self.mindsets, forKey: .mindsets)
        try container.encodeIfPresent(self.todos, forKey: .todos)
    }
}
