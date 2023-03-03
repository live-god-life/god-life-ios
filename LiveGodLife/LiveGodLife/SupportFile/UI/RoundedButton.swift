//
//  RoundedButton.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/12.
//

import UIKit

final class RoundedButton: UIButton {
    //MARK: - Initializer
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 56)))
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    //MARK: - Functions...
    func configure(title: String = "완료",
                   titleColor: UIColor = .black,
                   backgroundColor: UIColor = .green) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        titleLabel?.font = .semiBold(with: 18)
        clipsToBounds = true
        layer.cornerRadius = self.frame.height / 2
    }
}
