//
//  AppleLoginService.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/04.
//

import Foundation
import AuthenticationServices

protocol AppleLoginServiceDelegate: AnyObject {

    func signup()
}

final class AppleLoginService: NSObject, ASAuthorizationControllerDelegate {

    private weak var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?

    weak var delegate: AppleLoginServiceDelegate?

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
            let email = credential.email
            let data = ["identifier": identifier,
                        "type": LoginType.apple.rawValue]

            // 애플 로그인 인증 성공
            // 회원 인증했으면 홈으로
            // UserDefaults.standard.set(true, forKey: "IS_LOGIN") // 키체인으로 변경해야 함
            // 회원이 아니면 회원가입
            delegate?.signup()
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: - 실패 후 동작
        print("error")
    }
}
