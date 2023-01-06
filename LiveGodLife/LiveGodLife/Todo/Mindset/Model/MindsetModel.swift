//
//  MindsetModel.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/23.
//

import Foundation

struct MindSetsModel: Decodable, Hashable {
    var goalId: Int?
    var title: String?
    var mindsets: [MindSetModel]?
    
    enum Codingkeys: String, CodingKey {
        case title
        case goalId
    }
}

struct MindSetModel: Decodable, Hashable {
    var mindsetId: Int?
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case mindsetId
        case content
    }
}
