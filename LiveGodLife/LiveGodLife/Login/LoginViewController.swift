//
//  LoginViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/12.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {

    @IBOutlet weak var appleLoginButton: RoundedButton!
    @IBOutlet weak var kakaoLoginButton: RoundedButton!

    private var appleLoginService: AppleLoginService?

    override func viewDidLoad() {
        super.viewDidLoad()

        appleLoginService = AppleLoginService(presentationContextProvider: self)
        setupUI()
    }

    func setupUI() {
        appleLoginButton.configure(title: "Apple로 시작하기")
        kakaoLoginButton.configure(title: "카카오계정으로 시작하기")
    }

    @IBAction func didTapAppleLoginButton(_ sender: Any) {
        appleLoginService?.login()
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}

extension UIViewController {

    static func instance() -> Self? {
        let name = String(describing: self)
        return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: name) as? Self
    }
}
