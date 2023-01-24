//
//  SettingTableViewSection.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/21.
//

import Foundation

extension SettingTableViewSection: RawRepresentable {

    typealias RawValue = Int

    var rawValue: Int {
        switch self {
        case let .first(value), let .second(value):
            return value.count
        }
    }

    init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .first([.logout, .unregister])
        case 1:
            self = .second([.termsOfService, .privacyPolicy, .version])
        default:
            fatalError()
        }
    }
}
