//
//  RoundedButton.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/12.
//

import UIKit

final class RoundedButton: UIButton {

    func configure(title: String = "완료",
                   titleColor: UIColor = .label,
                   backgroundColor: UIColor = .green) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        titleLabel?.font = UIFont(name: "Pretendard", size: 18)
        clipsToBounds = true
        layer.cornerRadius = self.frame.height / 2
    }

    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 56)))
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
}
