//
//  UserInfoVC.swift
//  LiveGodLife
//
//  Created by wargi on 2022/03/08.
//

import UIKit
import SnapKit

final class UserInfoVC: UIViewController {
    //MARK: - Properties
    private let viewModel = UserViewModel()
    private let firstMainTitleLabel = UILabel().then {
        $0.text = "갓생살기에서 사용할"
        $0.textColor = .white
        $0.font = .semiBold(with: 28)
    }
    private let secondMainTitleLabel = UILabel().then {
        $0.text = "닉네임을 입력해주세요."
        $0.textColor = .white
        $0.font = .semiBold(with: 28)
    }
    private let firstSubTitleLabel = UILabel().then {
        $0.text = "유니코드 제외, 한글(8글자)"
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .regular(with: 16)
    }
    private let secondSubTitleLabel = UILabel().then {
        $0.text = "영어 가능(16자), 공백X, “_”가능, “-”불가능"
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .regular(with: 16)
    }
    private lazy var nickNameTextField = TextFieldView().then {
        $0.delegate = self
        $0.layer.cornerRadius = 28
    }
    private let nextButton = UIButton().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 27
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

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
        navigationController?.isNavigationBarHidden = false
        
        view.addSubview(firstMainTitleLabel)
        view.addSubview(secondMainTitleLabel)
        view.addSubview(firstSubTitleLabel)
        view.addSubview(secondSubTitleLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(nextButton)
  
        firstMainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(84)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
        }
        secondMainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(firstMainTitleLabel.snp.bottom)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(40)
        }
        firstSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(secondMainTitleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(24)
        }
        secondSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(firstSubTitleLabel.snp.bottom)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(24)
        }
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(secondSubTitleLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
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
        
        nickNameTextField
            .textPublisher
            .map { $0?.isEmpty ?? true }
            .sink { [weak self] isEmpty in
                self?.nickNameTextField.rightView?.isHidden = isEmpty
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
