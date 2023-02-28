//
//  UnregisterVC.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/26.
//

import UIKit
import SnapKit

final class UnregisterVC: UIViewController {
    //MARK: - Properties
    private let viewModel = UserViewModel()
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var unregisterButton: RoundedButton!
    @IBOutlet private weak var dimmedView: UIView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
    }
    
    //MARK: - Fuctions...
    private func makeUI() {
        title = "회원탈퇴"

        let text = ["목표관리,포함하여 회원님이 설정한 모든 정보가 사라지고 복구할 수 없어요.",
                    "회원님이 다른 사람에게 전달한 감사카드, 피드에 남긴 응원/공감/댓글은 삭제되지 않아요.",
                    "본인인증을 진행하신 회원님의 경우, 갓생살기 이벤트 및 기타 혜택에 대한 부정행위 방지를 위해 이메일과 휴대폰 번호 정보를 1개월간 보관 후 파기해요.",
                    "(애플 ID 로드인 회원인 경우) 정보 보안을 위해 애플 로그인 정보를 다시 한 번 확인하며, 탈퇴 완료 시 애플 계정 연동이 삭제 됩니다."]
        text.forEach {
            let contentLabel = UILabel()
            contentLabel.numberOfLines = 0
            contentLabel.textColor = .BBBBBB
            contentLabel.font = .bold(with: 16)
            let text = $0
            let attributed = text.attributed()
            contentLabel.attributedText = attributed
            contentStackView.addArrangedSubview(contentLabel)
        }

        checkButton.setImage(UIImage(named: "btn_toggle_checkbox_on_todo"), for: .selected)
        checkButton.setImage(UIImage(named: "btn_toggle_checkbox_off"), for: .normal)

        unregisterButton.configure(title: "탈퇴하기")
    }
    
    private func bind() {
        checkButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.checkButton.isSelected.toggle()
                self.unregisterButton.isEnabled = self.checkButton.isSelected
            }
            .store(in: &viewModel.bag)
        
        unregisterButton
            .tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                
                guard self.checkButton.isSelected else {
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
