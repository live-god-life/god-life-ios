//
//  RootViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/09/17.
//

import UIKit
import SnapKit

class RootViewController: UITabBarController, TabBarViewDelegate {

    private let tabBarView = TabBarView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        navigationItem.backButtonTitle = ""

        addObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !UserDefaults.standard.bool(forKey: "LIVE_GOD_LIFE") {
            let onboardingViewController = OnboardingViewController.instance()!
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: true)
            UserDefaults.standard.set(true, forKey: "LIVE_GOD_LIFE")
            return
        }

        // TODO: userdefaults 말고 키체인으로 처리해야 함
        if !UserDefaults.standard.bool(forKey: "IS_LOGIN") {
            routeToLogin()
            return
        }

        if isBeingPresented || isMovingToParent {
            NotificationCenter.default.post(name: .moveToHome, object: self)
        }
    }

    private func setupTabBar() {
        tabBarView.delegate = self
        view.addSubview(tabBarView)
        tabBarView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(104)
        }

        setViewControllers([HomeViewController(), TodoMainTabBarController(), MyPageViewController.instance()!], animated: true)
        selectedIndex = 0
        tabBarView.homeButton.isSelected = true
    }

    func setViewController(with index: Int) {
        selectedIndex = index
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .moveToHome, object: nil, queue: .main) { [weak self] _ in
            self?.setupTabBar()
        }

        NotificationCenter.default.addObserver(forName: .moveToLogin, object: nil, queue: .main) { [weak self] _ in
            self?.routeToLogin()
        }
    }

    private func routeToLogin() {
        let loginViewController = LoginViewController()
        let nav = UINavigationController(rootViewController: loginViewController)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

