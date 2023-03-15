//
//  LoginVC.swift
//  LiveGodLife
//
//  Created by wargi on 2022/03/09.
//

import UIKit
import Moya
import Lottie
import SnapKit
import KakaoSDKUser
import KakaoSDKAuth
import AuthenticationServices

final class LoginVC: UIViewController {
    //MARK: - Properties
    private var viewModel = UserViewModel()
    private let loginImageView = UIImageView().then {
        $0.image = UIImage(named: "loginBanner")
    }
    let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fillEqually
    }
    private let appleLoginButton = RoundedButton().then {
        $0.configure(title: "Apple로 시작하기", backgroundColor: .white)
    }
    private let kakaoLoginButton = RoundedButton().then {
        let kakaoColor = UIColor(red: 247/255, green: 227/255, blue: 23/255, alpha: 1)
        $0.configure(title: "카카오계정으로 시작하기", backgroundColor: kakaoColor)
    }
    private var appleLoginService: AppleLoginService?
    private let animationView = LottieAnimationView(name: "splash").then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .black
    }
    
    var email:String = ""
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
        
        animationView.play { [weak self] _ in
            if let _ = UserDefaults.standard.string(forKey: UserService.ACCESS_TOKEN_KEY) {
                let homeVC = UINavigationController(rootViewController: RootVC())
                homeVC.modalPresentationStyle = .fullScreen
                self?.present(homeVC, animated: false) {
                    self?.animationView.removeFromSuperview()
                }
            } else {
                self?.animationView.removeFromSuperview()
            }
        }
    }

    //MARK: - MakeUI
    private func makeUI() {
        view.backgroundColor = .black
        navigationItem.backButtonTitle = ""
        
        view.addSubview(loginImageView)
        view.addSubview(buttonStackView)
        view.addSubview(animationView)
        
        buttonStackView.addArrangedSubview(appleLoginButton)
        buttonStackView.addArrangedSubview(kakaoLoginButton)
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-160)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(124)
        }
        loginImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-64.8)
            $0.width.equalTo(290.4)
            $0.height.equalTo(208.4)
        }
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel.input.request.send(.token)
        
        appleLoginService = AppleLoginService(presentationContextProvider: self)
        appleLoginService?.delegate = self
        
        appleLoginButton
            .tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                
                self.appleLoginService?.login()
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestSignIn
            .sink { [weak self] signIn in
                guard let self else { return }
                
                switch signIn {
                case .success:
                    let homeVC = UINavigationController(rootViewController: RootVC())
                    homeVC.modalPresentationStyle = .fullScreen
                    self.present(homeVC, animated: true)
                case .register:
                    self.navigationController?.pushViewController(UserInfoVC(), animated: true)
                case .error:
                    let alert = UIAlertController(title: "알림", message: "로그인이 실패하였습니다.\n다시 시도해주세요!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
            .store(in: &viewModel.bag)
        
        kakaoLoginButton
            .tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                
                // 카카오톡 설치 여부 확인
                // isKakaoTalkLoginAvailable() : 카톡 설치 되어있으면 true
                if (UserApi.isKakaoTalkLoginAvailable()) {
                    //카톡 설치되어있으면 -> 카톡으로 로그인
                    UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                        self.requestKakaoLogin(oauthToken: oauthToken, error: error)
                    }
                } else {
                    // 카톡 없으면 -> 계정으로 로그인
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        self.requestKakaoLogin(oauthToken: oauthToken, error: error)
                    }
                }
            }
            .store(in: &viewModel.bag)
    }

    func requestKakaoLogin(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            LogUtil.e(error)
            self.failLoginAlert()
            return
        }
        
        UserApi.shared.me { [weak self] (user, error) in
            let name = user?.id ?? 0
            let userInfo = user?.kakaoAccount
            
            let model = UserModel(nickname: userInfo?.name ?? "",
                                  type: .kakao,
                                  identifier: "\(name)",
                                  email: userInfo?.email ?? "", image: nil)
            
            self?.viewModel.input.request.send(.signin(model))
        }
    }
    
    func failLoginAlert() {
        let alert = UIAlertController(title: "알림", message: "로그인에 실패하였습니다.\n다시 시도해주세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}


extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}

extension LoginVC: AppleLoginServiceDelegate {
    func signup() {
        self.navigationController?.pushViewController(UserInfoVC(), animated: true)
    }
    
    func login() {
        let homeVC = UINavigationController(rootViewController: RootVC())
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: true)
    }
}
