//
//  ProfileUpdateViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/24.
//

import UIKit

final class ProfileUpdateViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var updateButton: RoundedButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        title = "프로필 수정"

        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2

        nicknameTextField.layer.borderColor = UIColor.white.cgColor
        nicknameTextField.layer.borderWidth = 1
        nicknameTextField.layer.cornerRadius = nicknameTextField.frame.height / 2

        updateButton.layer.cornerRadius = updateButton.frame.height / 2
    }

    @IBAction func didTapUpdateButton(_ sender: Any) {
    }
}
