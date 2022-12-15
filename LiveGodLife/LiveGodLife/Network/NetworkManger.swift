//
//  NetworkManger.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/12/14.
//

import Foundation
import Alamofire

class DefaultAlamofireSession:Alamofire.Session{
    
    static let shared:DefaultAlamofireSession = {
        
        let configration = URLSessionConfiguration.default
        
        configration.headers = .default
        configration.timeoutIntervalForRequest  = 10 // as seconds, you can set your request timeout
        configration.timeoutIntervalForResource = 10 // as seconds, you can set your resource timeout
        configration.requestCachePolicy         = .useProtocolCachePolicy
        
        return DefaultAlamofireSession(configuration: configration)
    }()
}

struct NetworkManager {
    
    static let shared = NetworkManager()
    static let reachabilityManager = Alamofire.NetworkReachabilityManager(host: LGLService.baseUrl)
    static var continueRequest:Bool = false
    
    struct LGLError {
        var errCode:String
        var errType:String
        var errMessage:String
    }
}
