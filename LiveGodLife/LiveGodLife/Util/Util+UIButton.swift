//
//  Util+UIButton.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/02.
//

import Foundation
import UIKit

extension UIButton {
    func configure(title: String = "다음",
                   titleColor: UIColor = .label,
                   backgroundImage: UIImage? = nil) {
        self.layer.cornerRadius = self.frame.height / 2
        self.setTitle(title, for: .normal)
        self.tintColor = titleColor
        self.setBackgroundImage(backgroundImage, for: .normal)
    }
}
