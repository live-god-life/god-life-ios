//
//  UserInfoViewController.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/09.
//

import UIKit

class UserInfoViewController: UIViewController {
    let nickNameTextField = UITextField()
    let nextButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        subtitleLabel.text = "유니코드 제외, 한글(8글자)\n 영어 가능(16자), 공백X,\n “_”가능, “-”불가능"
        subtitleLabel.textColor = .gray1
        subtitleLabel.font = UIFont(name: "Pretendard", size: 16)
        subtitleLabel.numberOfLines = 0

        
        self.nickNameTextField.placeholder = "닉네임을 입력해주세요."
        self.nickNameTextField.textColor = .white
        self.nickNameTextField.layer.borderColor = UIColor.white.cgColor
        self.nickNameTextField.backgroundColor = UIColor.white
        self.nickNameTextField.layer.cornerRadius = 25
        
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(63)
            $0.left.equalTo(view).offset(24)
            $0.right.equalTo(view).offset(-117)
            $0.height.equalTo(68)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(10)
            $0.left.equalTo(view).offset(24)
            $0.right.equalTo(view)
            $0.width.equalTo(274)
            $0.height.equalTo(48)
        }
        self.nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(98)
            $0.left.equalTo(view).offset(16)
            $0.right.equalTo(view).offset(-16)
            $0.height.equalTo(56)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(self.nickNameTextField.snp.bottom).offset(8)
            $0.left.equalTo(view).offset(28)
            $0.right.equalTo(view).offset(-27)
            $0.height.equalTo(1)
            
        }
        
        self.nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.left.equalTo(view).offset(16)
            $0.right.equalTo(view).offset(-16)
            $0.height.equalTo(56)
        }
    }
    
    @objc func next(_ sender:UIButton) {
        self.navigationController?.pushViewController(AgreementViewController(), animated: true)
    }
}
