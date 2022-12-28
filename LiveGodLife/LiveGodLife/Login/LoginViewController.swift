//
//  LoginViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/12.
//

import UIKit
import SnapKit
import AuthenticationServices
import KakaoSDKUser
import KakaoSDKAuth
import SwiftyJSON
import Moya

extension LoginViewController: AppleLoginServiceDelegate {

    func signup(_ user: UserModel) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(UserInfoViewController(user), animated: true)
        }
    }

    func login() {
        // 로그인 성공
        DispatchQueue.main.async { [weak self] in
            UserDefaults.standard.set(true, forKey: "IS_LOGIN") // 키체인으로 변경해야 함
            self?.dismiss(animated: true)
            NotificationCenter.default.post(name: .moveToHome, object: self)
        }
    }
}

final class LoginViewController: UIViewController {

    private var user: UserModel?
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let appleLoginButton = RoundedButton()
    private let kakaoLoginButton = RoundedButton()
    private var appleLoginService: AppleLoginService?
    private let authLookProvider = MoyaProvider<NetworkService>()
    
    var email:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appleLoginService = AppleLoginService(presentationContextProvider: self)
        appleLoginService?.delegate = self

        view.backgroundColor = .black
        navigationItem.backButtonTitle = ""
        setupUI()
    }

    private func setupUI() {
        titleLabel.text = "갓생살기"
        titleLabel.textColor = .white
        titleLabel.font = .bold(with: 26)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(79)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(34)
        }
        subtitleLabel.text = "꿈꾸는 갓생러들이 모인 곳"
        subtitleLabel.textColor = .gray1
        subtitleLabel.font = .regular(with: 16)
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(34)
        }

        setupButtons()
    }

    private func setupButtons() {
        appleLoginButton.configure(title: "Apple로 시작하기", backgroundColor: .white)
        appleLoginButton.addTarget(self, action: #selector(didTapAppleLoginButton), for: .touchUpInside)
        kakaoLoginButton.configure(title: "카카오계정으로 시작하기", backgroundColor: UIColor(red: 247/255, green: 227/255, blue: 23/255, alpha: 1))
        kakaoLoginButton.addTarget(self, action: #selector(didTapKaKaoLoginButton), for: .touchUpInside)

        let buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(appleLoginButton)
        buttonStackView.addArrangedSubview(kakaoLoginButton)
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.height.equalTo(132)
        }
    }

    @objc private func didTapAppleLoginButton() {
        appleLoginService?.login()
    }

    @objc private func didTapKaKaoLoginButton() {
        // 카카오톡 설치 여부 확인
        // isKakaoTalkLoginAvailable() : 카톡 설치 되어있으면 true
        if (UserApi.isKakaoTalkLoginAvailable()) {
            
            //카톡 설치되어있으면 -> 카톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                if let error = error {
//                    print(error)
//                } else {
//                    print("카카오 톡으로 로그인 성공")
//
//                    _ = oauthToken
//                    /// 로그인 관련 메소드 추가
//                }
//                let idToken = oauthToken?.idToken
                if let error = error {
                    print(error)
                } else {
                    print("카카오 계정으로 로그인 성공")
                }
                UserApi.shared.me { (user, error) in
                    let name = user?.id ?? 0
                    let token = user?.kakaoAccount

                    var parameter = Dictionary<String,Any>()
                    parameter.updateValue(name ?? "", forKey: "identifier")
                    parameter.updateValue("kakao", forKey: "type")
                    self.email = user?.kakaoAccount?.email ?? ""
                    self.user = .init(nickname: user?.kakaoAccount?.name ?? "", type: .kakao, identifier: String(name), email: self.email, image: "")
                    self.login(param: parameter)

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
                    
                    // 관련 메소드 추가
                }
                UserApi.shared.me { (user, error) in
                    let name = user?.id ?? 0
                    let token = user?.kakaoAccount

                    var parameter = Dictionary<String,Any>()
//                    “identifier” : “key”
//                      “type” : “apple, kakao”
                    parameter.updateValue(name ?? "", forKey: "identifier")
                    parameter.updateValue("kakao", forKey: "type")
                    self.email = user?.kakaoAccount?.email ?? ""
                    self.user = .init(nickname: user?.kakaoAccount?.name ?? "", type: .kakao, identifier: String(name), email: self.email, image: "")
                    self.login(param: parameter)

                }
            }
        }
    }
    func login(param:Dictionary<String,Any>) {
        print("param: \(param)")
        
        authLookProvider.request(.login(param)) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let result):
                do {
                    
                    let json = try result.mapJSON()
//                    let json = try JSON(filteredResponse.mapJSON())
                    let jsonData = json as? [String:Any] ?? [:]
                    print(json)
                    print("response:\(response)")
                    print("message:\(jsonData["message"] ?? "")")
                    
                    guard let user = self.user else { return }
                    self.navigationController?.pushViewController(UserInfoViewController(user), animated: false)
                
                } catch(let err) {
                    print("nickname err:\(err.localizedDescription)")
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }

}


extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}
