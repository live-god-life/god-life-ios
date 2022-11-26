//
//  RootViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/09/17.
//

import UIKit
import SnapKit



class RootViewController: UITabBarController, TabBarViewDelegate {
    static var isTest = false

    private let tabBarView = TabBarView()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        navigationController?.navigationBar.isHidden = true
        navigationItem.backButtonTitle = ""

        setupTabBar()

        NotificationCenter.default.addObserver(forName: .moveToLogin, object: nil, queue: .main) { [weak self] _ in
            let loginViewController = LoginViewController()
            let navVC = UINavigationController(rootViewController:loginViewController)
            navVC.isNavigationBarHidden = true
            navVC.modalPresentationStyle = .fullScreen
            self?.present(navVC, animated: true)

        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //todo: 유저 디폴트 처리 하기
        if RootViewController.isTest == false {
            if isBeingPresented || isMovingToParent {
                let onboardingViewController = OnboardingViewController.instance()!
                onboardingViewController.modalPresentationStyle = .fullScreen
                present(onboardingViewController, animated: true)
                RootViewController.isTest = true
            }
        }
    }

    private func setupTabBar() {
        tabBar.isHidden = true

        tabBarView.delegate = self
        view.addSubview(tabBarView)
        tabBarView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(104)
        }

        setViewControllers([HomeViewController(), UIViewController(), MyPageViewController.instance()!], animated: true)
        selectedIndex = 0
        tabBarView.homeButton.isSelected = true
    }

    func setViewController(with index: Int) {
        selectedIndex = index
    }
}

