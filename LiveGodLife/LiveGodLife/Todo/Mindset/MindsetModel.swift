//
//  MindsetModel.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/23.
//

import Foundation

struct MindSetModel: Codable {
    var goalId: Int
    var title: String
    var mindsets:[SubMindSetModel]
    enum Codingkeys: String, CodingKey{
        case title
        case goalId
    }
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.goalId = try container.decode(Int.self, forKey: .goalId)
//        self.title = try container.decode(String.self, forKey: .title)
//        self.mindsets = try container.decode([SubMindSetModel].self, forKey: .mindsets)
//    }
}

struct SubMindSetModel: Codable {
    var mindsetId: Int
    var content: String
    
    
    
    enum CodingKeys: String, CodingKey{
        case mindsetId
        case content
    }
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mindsetId, forKey: .mindsetId)
        try container.encode(content, forKey: .content)
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.mindsetId = try container.decode(Int.self, forKey: .mindsetId)
//        self.content = try container.decode(String.self, forKey: .content)
//    }
}
