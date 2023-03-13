//
//  UIFont+Resource.swift
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
    
    static func semiBold(with size: CGFloat) -> UIFont? {
        return UIFont(name: "Pretendard-SemiBold", size: size)
    }

    static func montserrat(with size: CGFloat, weight: UIFont.Weight) -> UIFont? {
        let rawValue: String
        switch weight {
        case .black:
            rawValue = "Black"
        case .bold:
            rawValue = "Bold"
        case .light:
            rawValue = "Light"
        case .medium:
            rawValue = "Medium"
        case .regular:
            rawValue = "Regular"
        case .semibold:
            rawValue = "SemiBold"
        case .thin:
            rawValue = "Thin"
        case .heavy:
            rawValue = "ExtraBold"
        case .ultraLight:
            rawValue = "ExtraLight"
        default:
            rawValue = "Regular"
        }
        return UIFont(name: "Montserrat-\(rawValue)", size: size)
    }
}

struct SystemFont {
    enum Weight: String, RawRepresentable {
        case Regular
        case Medium
        case Bold
        case Unknown
        
        var toSystem: UIFont.Weight {
            switch self {
            case .Regular: return .regular
            case .Medium: return .medium
            case .Bold: return .bold
            case .Unknown: return .regular  // DEFAULT REGULAR
            }
        }
    }
    
    static func get(name: String, size: CGFloat) -> UIFont {
        if let font = UIFont(name: name, size: size) {
            return font
        } else {
            let weight = Weight(rawValue: name.components(separatedBy: "-").last ?? Weight.Unknown.rawValue) ?? .Regular
            return UIFont.systemFont(ofSize: size, weight: weight.toSystem)
        }
    }
}

extension UIFont {
    struct Text {
        static var regular: String {
            return "Pretendard-Regular"
        }
        static var bold: String {
            return "Pretendard-Bold"
        }
    }
    
}

extension UIFont {
    class var title16: UIFont {
        return SystemFont.get(name: UIFont.Text.regular, size: 16.0)
    }
    class var title26Bold: UIFont {
        return SystemFont.get(name: UIFont.Text.bold, size: 26.0)
    }
}
