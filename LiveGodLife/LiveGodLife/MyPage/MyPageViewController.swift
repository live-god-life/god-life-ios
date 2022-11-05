//
//  MyPageViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/23.
//

import UIKit

final class MyPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.text = "MY PAGE"
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 18)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(moveToSettingView))
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }

    @objc private func moveToSettingView() {
        let settingViewController = SettingViewController()
        navigationController?.pushViewController(settingViewController, animated: true)
    }

    @IBAction func moveToProfileUpdateView(_ sender: UIButton) {
        let profileUpdateViewController = ProfileUpdateViewController.instance()!
        navigationController?.pushViewController(profileUpdateViewController, animated: true)
    }
}
