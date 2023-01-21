//
//  UserInfoVC.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/09.
//

import UIKit
import SnapKit

class UserInfoVC: UIViewController {
    let nickNameTextField = TextFieldView()
    let nextButton = UIButton()

    private var user: UserModel

    init(_ user: UserModel) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        navigationItem.backButtonTitle = ""
        self.navigationController?.isNavigationBarHidden = false

        setupUI()
    }

    private func setupUI() {
        let mainTitleLabel = UILabel()
        let subtitleLabel = UILabel()
        let lineView = UIView()
        
        mainTitleLabel.text = "갓생살기에서 사용할\n닉네임을 입력해주세요."
        mainTitleLabel.textColor = .white
        mainTitleLabel.font = UIFont(name: "Pretendard-Bold", size: 26)
        mainTitleLabel.numberOfLines = 0

        subtitleLabel.text = "유니코드 제외, 한글(8글자)\n영어 가능(16자), 공백X,\n “_”가능, “-”불가능"
        subtitleLabel.textColor = .gray1
        subtitleLabel.font = UIFont(name: "Pretendard", size: 16)
        subtitleLabel.numberOfLines = 0

        self.nickNameTextField.placeholder = "닉네임을 입력해주세요."
        self.nickNameTextField.layer.cornerRadius = 25
        nickNameTextField.delegate = self
        
        lineView.backgroundColor = .white
        
        self.nextButton.backgroundColor = .green
        self.nextButton.layer.cornerRadius = 25
        self.nextButton.setTitle("다음", for: .normal)
        self.nextButton.setTitleColor(.black, for: .normal)
        self.nextButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
        
        view.addSubview(mainTitleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(self.nickNameTextField)
        view.addSubview(lineView)
        view.addSubview(self.nextButton)
  
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.left.equalTo(view).offset(24)
            $0.height.equalTo(68)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(16)
            $0.left.equalTo(view).offset(24)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        self.nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(60)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(56)
        }
        self.nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(56)
        }
    }
    
    @objc func next(_ sender:UIButton) {
        user.nickname = nickNameTextField.text ?? ""
        self.navigationController?.pushViewController(AgreementVC(user), animated: true)
    }
}

extension UserInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
