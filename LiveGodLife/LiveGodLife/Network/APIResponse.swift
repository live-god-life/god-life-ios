//
//  APIResponse.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/08.
//

import Foundation

struct APIResponse: Decodable {

    enum Status: String, Decodable {
        case success
        case error
    }

    let status: Status
    let data: [String: String]?
    let code: Int?
    let message: String
}
