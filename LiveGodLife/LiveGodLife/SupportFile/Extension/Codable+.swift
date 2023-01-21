//
//  JSONCodableService.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/08.
//

import Foundation

protocol JSONDecodable {
    var decoder: JSONDecoder { get }
    func decode<T: Decodable>(with data: Data) -> T?
}

extension JSONDecodable {
    var decoder: JSONDecoder {
        return JSONDecoder()
    }

    func decode<T: Decodable>(with data: Data) -> T? {
        try? decoder.decode(T.self, from: data)
    }
}

extension Encodable {
    var toDictionary : [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: String] else { return nil }
        return dictionary
    }
}
