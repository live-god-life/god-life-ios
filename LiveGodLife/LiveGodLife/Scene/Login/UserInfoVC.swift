//
//  UserInfoVC.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/09.
//

import UIKit
import SnapKit

final class UserInfoVC: UIViewController {
    //MARK: - Properties
    private let viewModel = UserViewModel()
    private let nickNameTextField = TextFieldView()
    private let nextButton = UIButton()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
    }

    //MARK: - Functions...
    private func makeUI() {
        view.backgroundColor = .black

        navigationItem.backButtonTitle = ""
        self.navigationController?.isNavigationBarHidden = false
        
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
    
    private func bind() {
        nextButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self, let name = self.nickNameTextField.text, !name.isEmpty else {
                    let alert = UIAlertController(title: "알림", message: "닉네임을 입력해주세요.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self?.present(alert, animated: true)
                    return
                }
                
                self.viewModel.input.request.send(.nickname(name))
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestNickname
            .sink { [weak self] isCompleted in
                guard isCompleted else {
                    let alert = UIAlertController(title: "알림", message: "중복된 닉네임입니다.\n다른 닉네임으로 설정해주세요!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self?.present(alert, animated: true)
                    return
                }
                
                let agreementVC = AgreementVC()
                self?.navigationController?.pushViewController(agreementVC, animated: true)
            }
            .store(in: &viewModel.bag)
    }
}

extension UserInfoVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
