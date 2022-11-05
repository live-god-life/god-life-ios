//
//  UnregisterViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/26.
//

import UIKit

class UnregisterViewController: UIViewController {

    @IBOutlet weak var contentStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
}

extension String {

    func attributed() -> NSMutableAttributedString {
        let attributed = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributed.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributed.length))
        return attributed
    }
}
