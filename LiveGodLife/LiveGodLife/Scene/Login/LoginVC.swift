//
//  LoginVC.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/12.
//

import UIKit
import SnapKit
import AuthenticationServices
import KakaoSDKUser
import KakaoSDKAuth
import Moya

final class LoginVC: UIViewController {
    //MARK: - Properties
    private var viewModel = UserViewModel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let appleLoginButton = RoundedButton()
    private let kakaoLoginButton = RoundedButton()
    private var appleLoginService: AppleLoginService?
    private let authLookProvider = MoyaProvider<NetworkService>()
    
    var email:String = ""
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
        
        if let _ = UserDefaults.standard.string(forKey: UserService.ACCESS_TOKEN_KEY) {
            let homeVC = UINavigationController(rootViewController: RootVC())
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: false)
        }
    }

    //MARK: - MakeUI
    private func makeUI() {
        view.backgroundColor = .black
        navigationItem.backButtonTitle = ""
        
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
        appleLoginButton.configure(title: "Apple로 시작하기",
                                   backgroundColor: .white)
        kakaoLoginButton.configure(title: "카카오계정으로 시작하기",
                                   backgroundColor: UIColor(red: 247/255, green: 227/255, blue: 23/255, alpha: 1))

        let buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.addArrangedSubview(appleLoginButton)
        buttonStackView.addArrangedSubview(kakaoLoginButton)
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.height.equalTo(132)
        }
    }
    
    private func bind() {
        appleLoginService = AppleLoginService(presentationContextProvider: self)
        
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
