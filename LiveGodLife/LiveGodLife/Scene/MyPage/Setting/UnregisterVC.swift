//
//  UnregisterVC.swift
//  LiveGodLife
//
//  Created by wargi on 2022/03/08.
//

import UIKit
import SnapKit

final class UnregisterVC: UIViewController {
    //MARK: - Properties
    private let viewModel = UserViewModel()
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "회원탈퇴"
    }
    private let firstMainTitleLabel = UILabel().then {
        $0.text = "회원탈퇴 유의사항을"
        $0.textColor = .white
        $0.font = .semiBold(with: 28)
    }
    private let secondMainTitleLabel = UILabel().then {
        $0.text = "확인해 주세요."
        $0.textColor = .white
        $0.font = .semiBold(with: 28)
    }
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 16.0
    }
    private let agreeItemView = AgreeButtonView().then {
        $0.detailImageView.isHidden = true
        $0.titleLabel.text = "위 내용에 동의하고 탈퇴하겠습니다."
        $0.agreeButton.isUserInteractionEnabled = false
    }
    private let unregisterButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .green
        $0.titleLabel?.font = .semiBold(with: 18)
        $0.layer.cornerRadius = 27.0
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .gray4
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - Fuctions...
    private func makeUI() {
        view.addSubview(navigationView)
        view.addSubview(firstMainTitleLabel)
        view.addSubview(secondMainTitleLabel)
        view.addSubview(contentStackView)
        view.addSubview(lineView)
        view.addSubview(agreeItemView)
        view.addSubview(unregisterButton)
        
        let text = ["목표관리,포함하여 회원님이 설정한 모든 정보가 사라지고 복구할 수 없어요.",
                    "회원님이 다른 사람에게 전달한 감사카드, 피드에 남긴 응원/공감/댓글은 삭제되지 않아요.",
                    "본인인증을 진행하신 회원님의 경우, 갓생살기 이벤트 및 기타 혜택에 대한 부정행위 방지를 위해 이메일과 휴대폰 번호 정보를 1개월간 보관 후 파기해요.",
                    "(애플 ID 로드인 회원인 경우) 정보 보안을 위해 애플 로그인 정보를 다시 한 번 확인하며, 탈퇴 완료 시 애플 계정 연동이 삭제 됩니다."]
        text.forEach {
            let contentLabel = UILabel()
            contentLabel.numberOfLines = 0
            contentLabel.textColor = .white.withAlphaComponent(0.6)
            contentLabel.font = .regular(with: 16)
            let text = $0
            let attributed = text.attributed()
            contentLabel.attributedText = attributed
            contentStackView.addArrangedSubview(contentLabel)
        }
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        firstMainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        secondMainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(firstMainTitleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(secondMainTitleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        agreeItemView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        unregisterButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(54)
        }
    }
    
    private func bind() {
        agreeItemView
            .gesture()
            .sink { [weak self] _ in
                guard let self else { return }
                self.agreeItemView.isSelected.toggle()
            }
            .store(in: &viewModel.bag)
        
        unregisterButton
            .tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                
                guard self.agreeItemView.isSelected else {
                    let alert = UIAlertController(title: "알림", message: "체크 항목을 확인해주세요!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    return
                }
                let alert = UIAlertController(title: "알림", message: "정말 탈퇴하시겠습니까?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in
                    self.viewModel.input.request.send(.withdrawal)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .default)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true)
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestWithdrawal
            .sink { [weak self] isCompleted in
                guard let self else { return }
                
                guard isCompleted else {
                    let alert = UIAlertController(title: "알림", message: "회원탈퇴를 실패하였습니다.\n다시 시도해주세요!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    return
                }
                let alert = UIAlertController(title: "알림", message: "회원탈퇴가 성공하였습니다!", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default) { _ in
                    self.dismiss(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true)
            }
            .store(in: &viewModel.bag)
    }
}
