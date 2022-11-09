//
//  User.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/08.
//

import Foundation

struct UserModel: Codable {

   let nickname: String
   let type: LoginType
   let identifier: String
   let email: String?
}
