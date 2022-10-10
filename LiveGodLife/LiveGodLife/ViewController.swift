//
//  ViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/09/17.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import SwiftyJSON
import Moya

class ViewController: UIViewController {
    private let authLookProvider = MoyaProvider<LookService>()
    var email:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 카카오톡 설치 여부 확인
        // isKakaoTalkLoginAvailable() : 카톡 설치 되어있으면 true
        if (UserApi.isKakaoTalkLoginAvailable()) {
            
            //카톡 설치되어있으면 -> 카톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("카카오 톡으로 로그인 성공")
                    
                    _ = oauthToken
                    /// 로그인 관련 메소드 추가
                }
            }
        } else {

            // 카톡 없으면 -> 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                let idToken = oauthToken?.idToken
                if let error = error {
                    print(error)
                } else {
                    print("카카오 계정으로 로그인 성공")
                    
                    _ = oauthToken
                    // 관련 메소드 추가
                }
                UserApi.shared.me { (user, error) in
                    let name = user?.id
                    let token = user?.kakaoAccount
                    
                    print("name : \(name) - \(token)\n")
                    print("idToken : \(idToken)\n")
                    
                    var parameter = Dictionary<String,Any>()
//                    “identifier” : “key”
//                      “type” : “apple, kakao”
                    print("identifier: \(idToken?.count)")
                    parameter.updateValue(idToken ?? "", forKey: "identifier")
                    parameter.updateValue("kakao", forKey: "type")
                    self.email = user?.kakaoAccount?.email ?? ""
                    
                    self.login(param: parameter)
                    
                }
            }
        }
    }

    func login(param:Dictionary<String,Any>) {
        print("param: \(param)")
        
        authLookProvider.request(.login(param)) { response in
            switch response {
            case .success(let result):
                do {
                    
                    let json = try result.mapJSON()
//                    let json = try JSON(filteredResponse.mapJSON())
                    let jsonData = json as? [String:Any] ?? [:]
                    print(json)
                    print("response:\(response)")
                    print("message:\(jsonData["message"] ?? "")")
                    self.authLookProvider.request(.nickname) { response in
                        switch response {
                        case .success(let result):
                            do {
                                
                                let json = try result.mapJSON()
                                //                    let json = try JSON(filteredResponse.mapJSON())
                                let jsonData = json as? [String:Any] ?? [:]
                                print("response:\(response)")
                                print("message:\(jsonData["message"] ?? "")")
                                
//                                {
//                                   nickname : ”닉네임” ,
//                                   type : “apple, kakao” , ←소문자
//                                   identifier : “kakao or apple key”
//                                   email : “dasjdilasdjil@nasdla.com”
//                                }
                                var joinParam = Dictionary<String,Any>()
                                
                                joinParam.updateValue("hun", forKey: "nickname")
                                joinParam.updateValue("kakao", forKey: "type")
                                joinParam.updateValue(param["identifier"] ?? "", forKey: "identifier")
                                joinParam.updateValue(self.email, forKey: "email")

                                print("joinPraam : \(joinParam)")
                                self.authLookProvider.request(.join(joinParam)) { response in
                                    switch response {
                                    case .success(let result):
                                        do {
                                            
                                            let json = try result.mapJSON()
                                            //                    let json = try JSON(filteredResponse.mapJSON())
                                            let jsonData = json as? [String:Any] ?? [:]
                                            print("response:\(response)")
                                            print("message:\(jsonData["message"] ?? "")")
                                            
                                            

                                        } catch(let err) {
                                            print("join err:\(err.localizedDescription)")
                                        }
                                    case .failure(let err):
                                        print("join err:\(err.localizedDescription)")
                                    }
                                    
                                    
                                }
                                

                            } catch(let err) {
                                print("nickname err:\(err.localizedDescription)")
                            }
                        case .failure(let err):
                            print("nickname err:\(err.localizedDescription)")
                        }
                        
                        
                    }
                
                } catch(let err) {
                    print("nickname err:\(err.localizedDescription)")
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }

}

import Moya
enum LookService {
    case nickname
    case join(Dictionary<String,Any>)
    case otherDetail(String, Int)
    case login(Dictionary<String,Any>)

    
}
extension LookService: TargetType {
    public var baseURL: URL {
    // GeneralAPI 라는 구조체 파일에 서버 도메인이나 토큰 값을 적어두고 불러왔습니다.
        return URL(string:  "http://49.50.167.208:8000")!
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
        }
    }

    var sampleData: Data {
        return "@@".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case .nickname:
            return .requestPlain

//            return .requestParameters(parameters: ["nickname":"hun"], encoding: URLEncoding.default)
        case .otherDetail(_, _):
            return .requestPlain
        case .join(let parameter):
            
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)

        case .login(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "token": accessToken] // GeneralAPI.token
        }
    }
}

