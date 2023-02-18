//
//  CategoryModel.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/02.
//

import Foundation

enum CategoryCode: String {
    case lifeStyle = "생활습관"
    case workout = "운동"
    case career = "커리어"
    case finance = "돈관리"
    case hobby = "취미"
    case learning = "학습"
    case mindfulness = "마음챙김"
    case selfcare = "셀프케어"
    
    var code: String {
        switch self {
        case .lifeStyle:
            return "LIFESTYLE"
        case .workout:
            return "WORKOUT"
        case .career:
            return "CAREER"
        case .finance:
            return "FINANCE"
        case .hobby:
            return "HOBBY"
        case .learning:
            return "LEARNING"
        case .mindfulness:
            return "MINDFULNESS"
        case .selfcare:
            return "SELFCARE"
        }
    }
    
    static func name(category code: String) -> String {
        switch code {
        case "LIFESTYLE":
            return "생활습관"
        case "WORKOUT":
            return "운동"
        case "CAREER":
            return "커리어"
        case "FINANCE":
            return "돈관리"
        case "HOBBY":
            return "취미"
        case "LEARNING":
            return "학습"
        case "MINDFULNESS":
            return "마음챙김"
        default:
            return "셀프케어"
        }
    }
}

struct CategoryModel: Hashable {
    var name: String
    var isSelected: Bool
    
    static func models() -> [Self] {
        return [Self(name: "생활습관", isSelected: false),
                Self(name: "운동", isSelected: false),
                Self(name: "커리어", isSelected: false),
                Self(name: "돈관리", isSelected: false),
                Self(name: "취미", isSelected: false),
                Self(name: "학습", isSelected: false),
                Self(name: "마음챙김", isSelected: false),
                Self(name: "셀프케어", isSelected: false)]
    }
}
