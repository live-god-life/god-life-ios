//
//  AppleLoginService.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/04.
//

import Foundation
import AuthenticationServices

class AppleLoginService: JSONDecodeService, ASAuthorizationControllerDelegate {

    private weak var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?

//    private let signupCompletionHandler: (User) -> Void
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

            let requestManager = APIRequestManager.shared
            requestManager.request(endpoint: .login(data)) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.loginSuccessCompletionHandler(data)
                case .failure(let error):
                    guard let data = error.data,
                          let response: APIResponse = self?.decode(with: data) else {
                        // TODO: 예외 처리
                        return
                    }
                    if response.status == .error, response.code == 401 {
                        // 회원이 아님
                        let user = User(nickname: "", type: .apple, identifier: identifier, email: email)
    //                    self?.signupCompletionHandler(user)
                    } else {
                        // 잘못된 접근 error
                    }
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: - 실패 후 동작
        print("error")
    }
}
