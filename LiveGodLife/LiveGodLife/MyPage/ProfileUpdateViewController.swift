//
//  ProfileUpdateViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/24.
//

import UIKit

final class ProfileUpdateViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameTextField: TextFieldView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        title = "프로필 수정"

        setupProfileImageView()
    }
    
    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.makeBorderGradation(startColor: .green, endColor: .blue)
    }
}
