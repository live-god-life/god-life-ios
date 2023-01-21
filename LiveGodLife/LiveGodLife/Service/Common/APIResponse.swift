//
//  APIResponse.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/08.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {

    enum Status: String, Decodable {
        case success
        case error
    }

    let status: Status
    let data: T?
    let code: Int?
    let message: String?
}
