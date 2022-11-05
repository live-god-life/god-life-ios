//
//  SettingTableViewCellViewModel.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/26.
//

import Foundation

enum SettingTableViewCellViewModel: Int, CaseIterable {

    case logout
    case unregister
    case termsOfService
    case privacyPolicy
    case version

    var title: String {
        switch self {
        case .logout:
            return "로그아웃"
        case .unregister:
            return "회원탈퇴"
        case .termsOfService:
            return "서비스 이용 약관"
        case .privacyPolicy:
            return "개인정보처리방침"
        case .version:
            return "버전 정보"
        }
    }

    var image: String {
        switch self {
        case .version:
            return ""
        default:
            return "chevron.right"
        }
    }

    var subtitle: String {
        switch self {
        case .version:
            return "v1.0"
        default:
            return ""
        }
    }
}
