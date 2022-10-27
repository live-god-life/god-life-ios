//
//  LoginViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/12.
//

import UIKit
import SnapKit
import AuthenticationServices

final class LoginViewController: UIViewController {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let appleLoginButton = RoundedButton()
    private let kakaoLoginButton = RoundedButton()

    private var appleLoginService: AppleLoginService?

    override func viewDidLoad() {
        super.viewDidLoad()

        appleLoginService = AppleLoginService(presentationContextProvider: self)
        setupUI()
    }

    private func setupUI() {
        titleLabel.text = "갓생살기"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 26)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(79)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(34)
        }
        subtitleLabel.text = "꿈꾸는 갓생러들이 모인 곳"
        subtitleLabel.textColor = .gray1
        subtitleLabel.font = UIFont(name: "Pretendard", size: 16)
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

    @objc private func didTapKaKaoLoginButton() { }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}
