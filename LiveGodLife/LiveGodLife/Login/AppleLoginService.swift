//
//  AppleLoginService.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/04.
//

import Foundation
import AuthenticationServices

class AppleLoginService: JSONDecodeService, ASAuthorizationControllerDelegate {

    private let signupCompletionHandler: (User) -> Void
    private lazy var loginSuccessCompletionHandler: (Data?) -> Void = { [weak self] data in
        guard let data = data,
              let response: APIResponse = self?.decode(with: data),
              let authToken = response.data?["authorization"] else {
            // TODO: error handle
            return
        }
        // TODO: UserDefaults 저장
        print(authToken)
    }

    init(signupCompletionHandler: @escaping (User) -> Void) {
        self.signupCompletionHandler = signupCompletionHandler
    }

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
            let email = credential.email
            let data = ["identifier": identifier,
                        "type": LoginType.apple.rawValue]

            let requestManager = APIRequestManager.shared
            requestManager.request(endpoint: .login(data)) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.loginSuccessCompletionHandler(data)
                case .failure(let error):
                    guard let data = error.data,
                          let response: APIResponse = self?.decode(with: data),
                          response.status == .error, response.code == 401 else {
                        // TODO: 예외 처리
                        return
                    }
                    let user = User(nickname: "", type: .apple, identifier: identifier, email: email)
                    self?.signupCompletionHandler(user)
                }
            }
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
