//
//  MindsetModel.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/23.
//

import Foundation

/*
 {
   "status": "success",
   "message": "ok",
   "data": [
     {
       "goalId": 1,
       "title": "이직하기",
       "mindsets": [
         {
           "mindsetId": 1,
           "content": "사는건 레벨업이 아닌 스펙트럼을 넓히는 거란 얘길 들었다. 어떤 말보다 용기가 된다111."
         }
       ]
     }
   ]
 }
 */
struct MindSetModel: Codable {
    var goalId: Int
    var title: String
    var mindsets:[SubMindSetModel]
    enum Codingkeys: Int,CodingKey{
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
    enum Codingkeys: Int,CodingKey{
        case mindsetId
    }
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.mindsetId = try container.decode(Int.self, forKey: .mindsetId)
//        self.content = try container.decode(String.self, forKey: .content)
//    }
}
