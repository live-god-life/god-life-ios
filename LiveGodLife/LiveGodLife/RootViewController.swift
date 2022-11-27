//
//  RootViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/09/17.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: .moveToLogin, object: nil, queue: .main) { [weak self] _ in
//            let loginViewController = MindsetListViewController()
//            self?.present(loginViewController, animated: true)
            
            
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if isBeingPresented || isMovingToParent {
            let onboardingViewController = OnboardingViewController.instance()!
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: true)
        }
    }
}

