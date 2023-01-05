//
//  MindsetModel.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/23.
//

import Foundation

struct MindSetModel: Decodable {
    var goalId: Int
    var title: String
    var mindsets: [SubMindSetModel]
    
    enum Codingkeys: String, CodingKey {
        case title
        case goalId
    }
}

struct SubMindSetModel: Decodable {
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
}
