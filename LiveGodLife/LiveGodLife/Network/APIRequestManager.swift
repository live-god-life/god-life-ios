//
//  APIRequestManager.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/08.
//

import Foundation
import Alamofire

struct APIError: Error {

    let data: Data?
}

final class APIRequestManager {

    static let shared = APIRequestManager()

    func request(endpoint: Endpoint, header: HTTPHeaders? = nil, completion: @escaping (Result<Data?, APIError>) -> Void) {
        var request = URLRequest(url: endpoint.url)
        request.method = endpoint.method
        request.httpBody = try! JSONSerialization.data(withJSONObject: endpoint.data)
        AF.request(endpoint.url, method: endpoint.method, headers: header)
            .responseJSON { responseData in
                if let response = responseData.response,
                   (200..<300).contains(response.statusCode) {
                    completion(.success(responseData.data))
                } else {
                    completion(.failure(APIError(data: responseData.data)))
                }
            }
    }
}
