//
//  AppleLoginService.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/04.
//

import Foundation
import AuthenticationServices
import Combine

protocol AppleLoginServiceDelegate: AnyObject {
    func signup()
    func login()
}

final class AppleLoginService: NSObject {
    private weak var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?

    private var viewModel = UserViewModel()
    weak var delegate: AppleLoginServiceDelegate?

    private var bag = Set<AnyCancellable>()

    init(presentationContextProvider: ASAuthorizationControllerPresentationContextProviding) {
        self.presentationContextProvider = presentationContextProvider
        
        super.init()
        
        bind()
    }
    
    private func bind() {
        viewModel
            .output
            .requestSignIn
            .sink { [weak self] signIn in
                guard let self else { return }
                
                switch signIn {
                case .success:
                    self.delegate?.login()
                case .register:
                    self.delegate?.signup()
                case .error:
                    let alert = UIAlertController(title: "알림", message: "로그인이 실패하였습니다.\n다시 시도해주세요!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    UIApplication.topViewController()?.present(alert, animated: true)
                }
            }
            .store(in: &viewModel.bag)
    }

    func login() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = presentationContextProvider
        controller.performRequests()
    }
}

extension AppleLoginService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        var user = UserModel(nickname: "", type: .apple, identifier: credential.user, email: "", image: nil)
        
        
        if let email = credential.email {
            user.email = email
        } else {
            if let token = credential.identityToken,
               let tokenString = String(data: token, encoding: .utf8) {
                let email = tokenString.decode()["email"] as? String ?? ""
                user.email = email
            }
        }
        
        viewModel.input.request.send(.signin(user))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        LogUtil.e("error")
    }
}
