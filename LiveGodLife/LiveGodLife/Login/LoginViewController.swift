//
//  LoginViewController.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/02.
//

import UIKit
import SnapKit
import KakaoSDKAuth
import SwiftyJSON
import Moya
import KakaoSDKUser

class LoginViewController: UIViewController {
    let kakaoButton = UIButton()    // 카카오 로그인
    let appleButton = UIButton()    // 애플 로그인
    var email:String = ""
    private let authLookProvider = MoyaProvider<LookService>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        // setting UI
        self.appleButton.configure(title: "Apple로 시작하기")
        self.kakaoButton.configure(title: "카카오계정으로 시작하기")
        
        self.appleButton.backgroundColor = .white
        self.kakaoButton.backgroundColor = .yellow
        self.appleButton.setTitleColor(.black, for: .normal)
        self.kakaoButton.setTitleColor(.black, for: .normal)
        self.kakaoButton.addTarget(self, action: #selector(self.kakaoLogin(_:)), for: .touchUpInside)

        // add viwe
        self.view.addSubview(self.appleButton)
        self.view.addSubview(self.kakaoButton)
        
        
        // setting UI layout
        self.appleButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaInsets.bottom).offset(-20)
            make.left.equalTo(self.view.safeAreaInsets).offset(10)
            make.right.equalTo(self.view.safeAreaInsets).offset(-10)
            make.height.equalTo(40)
        }
        
        self.kakaoButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.appleButton.snp.bottom).offset(-50)
            make.left.equalTo(self.appleButton)
            make.right.equalTo(self.appleButton)
            make.height.equalTo(40)

        }
        
//        var param:[String:Any] = [:]
//        param.updateValue(20221010, forKey: "date")
//        param.updateValue(0, forKey: "page")
//        param.updateValue(25, forKey: "size")
//        param.updateValue("false", forKey: "completionStatus")
//
//        authLookProvider.request(.todos(param)) { response in
//            switch response {
//            case .success(let result):
//                do {
//
//                    let json = try result.mapJSON()
////                    let json = try JSON(filteredResponse.mapJSON())
//                    let jsonData = json as? [String:Any] ?? [:]
//                    print(json)
//                    print("response:\(response)")
//                    print("message:\(jsonData["message"] ?? "")")
//
//                } catch(let err) {
//                    print("nickname err:\(err.localizedDescription)")
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
    }
    
    @objc func kakaoLogin(_ sender: UIButton) {
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
    
//    func callLogin(param:Dictionary<String,Any>){
//
//        APIRequestManager.shared.request(endpoint: .login(param)) { [weak self] result in
//            switch result {
//            case .success(let data):
//                self?.loginSuccessCompletionHandler(data)
//            case .failure(let error):
//                guard let data = error.data,
//                      let response: APIResponse = self?.decode(with: data) else {
//                    // TODO: 예외 처리
//                    return
//                }
//                if response.status == .error, response.code == 401 {
//                    // 회원이 아님
////                    let user = User(nickname: "", type: .apple, identifier: identifier, email: email)
////                    self?.signupCompletionHandler(user)
//                } else {
//                    // 잘못된 접근 error
//                }
//            }
//        }
//    }

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
//                    self.authLookProvider.request(.nickname) { response in
//                        switch response {
//                        case .success(let result):
//                            do {
//
//                                let json = try result.mapJSON()
//                                //                    let json = try JSON(filteredResponse.mapJSON())
//                                let jsonData = json as? [String:Any] ?? [:]
//                                print("response:\(response)")
//                                print("message:\(jsonData["message"] ?? "")")
//
////                                {
////                                   nickname : ”닉네임” ,
////                                   type : “apple, kakao” , ←소문자
////                                   identifier : “kakao or apple key”
////                                   email : “dasjdilasdjil@nasdla.com”
////                                }
//                                var joinParam = Dictionary<String,Any>()
//
//                                joinParam.updateValue("hun", forKey: "nickname")
//                                joinParam.updateValue("kakao", forKey: "type")
//                                joinParam.updateValue(param["identifier"] ?? "", forKey: "identifier")
//                                joinParam.updateValue(self.email, forKey: "email")
//
//                                print("joinPraam : \(joinParam)")
//                                self.authLookProvider.request(.join(joinParam)) { response in
//                                    switch response {
//                                    case .success(let result):
//                                        do {
//
//                                            let json = try result.mapJSON()
//                                            //                    let json = try JSON(filteredResponse.mapJSON())
//                                            let jsonData = json as? [String:Any] ?? [:]
//                                            print("response:\(response)")
//                                            print("message:\(jsonData["message"] ?? "")")
//
//
//
//                                        } catch(let err) {
//                                            print("join err:\(err.localizedDescription)")
//                                        }
//                                    case .failure(let err):
//                                        print("join err:\(err.localizedDescription)")
//                                    }
//
//
//                                }
//
//
//                            } catch(let err) {
//                                print("nickname err:\(err.localizedDescription)")
//                            }
//                        case .failure(let err):
//                            print("nickname err:\(err.localizedDescription)")
//                        }
//
//
//                    }

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
    case todos(Dictionary<String,Any>)


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
        case .todos(_):
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

//            return .requestParameters(parameters: ["nickname":"hun"], encoding: URLEncoding.default)
        case .otherDetail(_, _):
            return .requestPlain
        case .join(let parameter):

            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)

        case .login(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        case .todos(let parameter):
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

