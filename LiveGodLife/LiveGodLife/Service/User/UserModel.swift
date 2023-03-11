//
//  User.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/08.
//

import Foundation

//MARK: - 회원가입, 로그인 정보
struct UserModel: Codable, Hashable {
    var nickname: String
    let type: LoginType?
    let identifier: String?
    var email: String?
    var image: String?
    var marketingYn: String?

    init(nickname: String, type: LoginType?, identifier: String?, email: String?, image: String?) {
        self.nickname = nickname
        self.type = type
        self.identifier = identifier
        self.email = email
        self.image = image
    }

    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

//MARK: - 전체 프로필 이미지
struct ProfileImage: Decodable, Hashable {
    let url: String?
}

//MARK: - 약관 정보
struct Term: Decodable, Hashable {
    enum TermType: String, Decodable {
        case use = "USE"
        case privacy = "PRIVACY"
        case marketing = "MARKETING"
    }
    
    let type: TermType?
    let version: String?
    let contents: String?
    let required: Bool?
    
    enum CodingKeys: CodingKey {
        case type
        case version
        case contents
        case required
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(Term.TermType.self, forKey: .type)
        self.version = try container.decodeIfPresent(String.self, forKey: .version)
        self.contents = try container.decodeIfPresent(String.self, forKey: .contents)
        let isRequired = try container.decodeIfPresent(String.self, forKey: .required)
        self.required = isRequired == "Y"
    }
}

//MARK: - 토큰 정보
struct UserToken: Decodable, Hashable {
    let authorization: String?
}

//MARK: - 회원가입, 로그인 정보
//MARK: - 회원가입, 로그인 정보
//MARK: - 회원가입, 로그인 정보


