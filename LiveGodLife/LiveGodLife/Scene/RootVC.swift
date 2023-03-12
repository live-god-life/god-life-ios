//
//  RootVC.swift
//  LiveGodLife
//
//  Created by Ador on 2022/09/17.
//

import UIKit
import SnapKit

final class RootVC: UITabBarController {
    //MARK: - Properties
    private let tabBarView = TabBarView()

    //MARK: - Life Cycle
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
        
        guard let homeVC = HomeVC.instance() else {
            LogUtil.e("HomeVC 생성 실패")
            return
        }
        let todoTabBar = TodoMainTabBarController()
        
        let myPageVC = MyPageVC()
        setViewControllers([homeVC, todoTabBar, myPageVC], animated: true)
        selectedIndex = 0
        tabBarView.homeButton.isSelected = true
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
        let loginVC = LoginVC()
        let nav = UINavigationController(rootViewController: loginVC)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

extension RootVC: TabBarViewDelegate {
    func setViewController(with index: Int) {
        selectedIndex = index
    }
}

extension Notification.Name {
    static let moveToLogin = Notification.Name("MOVE_TO_LOGIN")
    static let moveToHome = Notification.Name("MOVE_TO_HOME")
}
