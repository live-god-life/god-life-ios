//
//  AppleLoginService.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/04.
//

import Foundation
import AuthenticationServices

final class AppleLoginService: NSObject, ASAuthorizationControllerDelegate {

    private weak var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?


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

        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: - 실패 후 동작
        print("error")
    }
}
