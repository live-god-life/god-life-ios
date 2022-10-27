//
//  RoundedButton.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/12.
//

import UIKit

final class RoundedButton: UIButton {

    func configure(title: String = "다음",
                   titleColor: UIColor = .label,
                   backgroundColor: UIColor = .white) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = UIFont(name: "Pretendard", size: 18)
        self.backgroundColor = backgroundColor
    }

    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 56)))
        layer.cornerRadius = self.frame.height / 2
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
