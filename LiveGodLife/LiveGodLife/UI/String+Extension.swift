//
//  String+Extension.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/06.
//

import UIKit

extension String {

    func attributed() -> NSMutableAttributedString {
        let attributed = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributed.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributed.length))
        return attributed
    }
}
