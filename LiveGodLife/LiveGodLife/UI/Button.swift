//
//  Button.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/12.
//

import UIKit

extension UIColor {

    static let neonGreen = UIColor(red: 124, green: 252, blue: 0, alpha: 1)
}

class RoundedButton: UIButton {

    func configure(title: String = "다음",
                   titleColor: UIColor,
                   backgroundImage: UIImage? = nil,
                   backgroundColor: UIColor = .neonGreen) {
        layer.cornerRadius = self.frame.height / 2
        setTitle(title, for: .normal)
        tintColor = titleColor
        setBackgroundImage(backgroundImage, for: .normal)
        layer.backgroundColor = backgroundColor.cgColor
    }
}
