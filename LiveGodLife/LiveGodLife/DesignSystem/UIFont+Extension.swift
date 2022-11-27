//
//  UIFont+Extension.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/05.
//

import UIKit

extension UIFont {

    static func bold(with size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Bold", size: size)
    }

    static func regular(with size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Regular", size: size)
    }

    static func medium(with size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-Medium", size: size)
    }

    static func montserrat(with size: CGFloat, weight: UIFont.Weight) -> UIFont? {
        let rawValue: String
        switch weight {
        case .bold:
            rawValue = "Bold"
        default:
            rawValue = "Regular"
        }
        return UIFont(name: "Montserrat-\(rawValue)", size: size)
    }
}
