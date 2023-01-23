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

    func signup(_ user: UserModel)
    func login()
}

final class AppleLoginService: NSObject, ASAuthorizationControllerDelegate {

    private weak var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?

    weak var delegate: AppleLoginServiceDelegate?

    private var bag = Set<AnyCancellable>()

    init(presentationContextProvider: ASAuthorizationControllerPresentationContextProviding) {
        self.presentationContextProvider = presentationContextProvider
    }

    func login() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = presentationContextProvider
        controller.performRequests()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let identifier = credential.user
            let email = credential.email ?? ""
            let data = ["identifier": identifier,
                        "email": email,
                        "type": LoginType.apple.rawValue]

            DefaultUserRepository().login(endpoint: .login(data))
                .sink { _ in
            } receiveValue: { [weak self] value in
                // 회원이 아니면 회원가입
                let user = UserModel(nickname: "", type: .apple, identifier: identifier, email: email, image: nil)
                if value.code == 401 {
                    self?.delegate?.signup(user)
                    return
                }

                // 회원이면 홈으로
                if let token = value.data?.authorization {
                    UserDefaults.standard.set(token, forKey: "token")
                    self?.delegate?.login()
                }
            }
            .store(in: &bag)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: - 실패 후 동작
        LogUtil.e("error")
    }
}
