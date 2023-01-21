//
//  LGLService.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/12/14.
//

import Foundation
import Moya
import SwiftyJSON
import PopupDialog
import SystemConfiguration
import os
import WebKit
import AdSupport

enum LGLService{
    static var baseUrl: String{
        return "http://101.101.208.221:80"
    }
    case nickname
    case join(Dictionary<String,Any>)
    case otherDetail(String, Int)
    case login(Dictionary<String,Any>)
    case todos(Dictionary<String,Any>)
    
    struct Error: Swift.Error, LocalizedError{}
}


extension LGLService: TargetType{
    public var baseURL: URL {
    // GeneralAPI 라는 구조체 파일에 서버 도메인이나 토큰 값을 적어두고 불러왔습니다.
        return URL(string:  "http://101.101.208.221:80")!
    }

    var path: String {
        switch self {
        case .nickname:
            return "/nickname/hun"
        case .otherDetail(let userID, let index):
            return "/other/detail/\(userID)/\(index)"
        case .join(_):
            return "/users"
        case .login(_):
            return "/login"
        case .todos(_):
            return "/goals/todos"
        }
    }

    var method: Moya.Method {
        switch self {
        case .nickname:
            return .get
        case .otherDetail:
            return .get
        case .join(_):
            return .post
        case .login(_):
            return .post
        case .todos:
            return .get
        }
    }

    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case .nickname:
            return .requestPlain
        case .otherDetail(_, _):
            return .requestPlain
        case .join(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        case .login(let parameter):
            let data = try! JSONSerialization.data(withJSONObject: parameter)
            return .requestData(data)
        case .todos(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)

//            let data = try! JSONSerialization.data(withJSONObject: parameter)
//            return .requestData(data)
        }
    }
    
    var headers: [String: String]? {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer test"] // GeneralAPI.token
        }
    }

//    var headers: [String : String]? {
//        return ["Content-Type": "application/json"]
//    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
class LGLServiceAuth: PluginType{
    
    let authHeaderKey = "authorization"

    func prepare(_ urlRequest: URLRequest, target: TargetType) -> URLRequest {
        
//        if UserDefaults.standard.string(forKey: "accessToken")?.isEmpty ?? true {
//            return urlRequest
//        }
//        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
//        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""

        var request = urlRequest
//        request.setValue("Bearer test", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
//        if request.allHTTPHeaderFields?.keys.contains(authHeaderKey) ?? false{
//            request.setValue(refreshToken, forHTTPHeaderField: authHeaderKey)
//        }
//        else {
//            request.addValue(accessToken,  forHTTPHeaderField: "Authorization")
//            request.addValue(refreshToken, forHTTPHeaderField: "X-AUTH-RT")
//        }
        return request
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        #if DEBUG
        if let absoluteString = request.request?.url?.absoluteString {
            print("willSend\n** \(absoluteString) **\n\(target)")
        }
        #endif

//        let status = ReachabilityStatus()
//        if status.currentReachabilityStatus == .notReachable{
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                if !(UIApplication.topViewController() is NetworkErrorController) {
//                    let view = NetworkErrorController()
//                    view.modalPresentationStyle = .currentContext
//                    UIApplication.topViewController()?.present(view, animated: false, completion: nil)
//                }
//            }
//        }
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        #if DEBUG
        switch result {
        case .success(_):
            LGLLog.log("didReceive\n[성공] \(target)", category: "Network")
        case .failure(let error):
            LGLLog.log("didReceive\n[실패] \(target)\n[에러] \(error.localizedDescription)", category: "Network")
        }
        #endif
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }
}

class LGLLog {
    static func log(_ message: String, category: String = "Muffin") {
#if DEBUG
        if #available(iOS 14.0, *) {
            let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: category)
            logger.trace("\(message)")
        } else {
            os_log("[%@] %@", log: .default, type: .default, category, message)
        }
#endif
    }
    
    static func debug(_ message: String, category: String = "Muffin") {
#if DEBUG
        if #available(iOS 14.0, *) {
            let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "debug")
            logger.debug("[\(category)] \(message)")
        } else {
            os_log("[debug] [%@] %@", log: .default, type: .debug, category, message)
        }
#endif
    }
    
    static func info(_ message: String, category: String = "Muffin") {
#if DEBUG
        if #available(iOS 14.0, *) {
            let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "info")
            logger.info("[\(category)] \(message)")
        } else {
            os_log("[info] [%@] %@", log: .default, type: .info, category, message)
        }
#endif
    }
    
    static func warning(_ message: String, category: String = "Muffin") {
#if DEBUG
        if #available(iOS 14.0, *) {
            let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "warning")
            logger.warning("[\(category)] \(message)")
        } else {
            os_log("[warning] [%@] %@", log: .default, type: .error, category, message)
        }
#endif
    }
    
    static func error(_ message: String, category: String = "Muffin") {
#if DEBUG
        if #available(iOS 14.0, *) {
            let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "error")
            logger.error("[\(category)] \(message)")
        } else {
            os_log("[error] [%@] %@", log: .default, type: .error, category, message)
        }
#endif
    }
    
    static func critical(_ message: String, category: String = "Muffin") {
#if DEBUG
        if #available(iOS 14.0, *) {
            let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "critical")
            logger.critical("[\(category)] \(message)")
        } else {
            os_log("[critical] [%@] %@", log: .default, type: .fault, category, message)
        }
#endif
    }
      
}




