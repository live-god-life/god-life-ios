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
}

final class AppleLoginService: NSObject, ASAuthorizationControllerDelegate {

    private weak var presentationContextProvider: ASAuthorizationControllerPresentationContextProviding?

    weak var delegate: AppleLoginServiceDelegate?

    private var cancellable = Set<AnyCancellable>()

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

            DefaultUserRepository().login(endpoint: .login(data))
                .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] data in
                // 회원이 아니면 회원가입
                let user = UserModel(nickname: "", type: .apple, identifier: identifier, email: email, image: nil)
                if data.code == 401 {
                    self?.delegate?.signup(user)
                    return
                }
                NotificationCenter.default.post(name: .moveToHome, object: self)
            }
            .store(in: &cancellable)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // TODO: - 실패 후 동작
        print("error")
    }
}
