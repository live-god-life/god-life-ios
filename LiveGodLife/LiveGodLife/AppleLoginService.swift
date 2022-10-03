//
//  AppleLoginService.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/04.
//

import Foundation
import AuthenticationServices

class AppleLoginService: NSObject, ASAuthorizationControllerDelegate {
    
    static let shared = AppleLoginService()
    
    @objc func didTapAppleLoginButton() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let identifier = credential.user
            // TODO: /login API call
            print(identifier)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: - 실패 후 동작
        print("error")
    }
}

// TODO: - AuthenticationServices
//extension ViewController: ASWebAuthenticationPresentationContextProviding {
//    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
//        return self.view.window ?? ASPresentationAnchor()
//    }
//}
