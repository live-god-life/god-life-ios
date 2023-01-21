//
//  UIColor+.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/24.
//

import UIKit

extension UIColor {
    convenience init(colorSet: CGFloat) {
        self.init(red: colorSet/255, green: colorSet/255, blue: colorSet/255, alpha: 1.0)
    }
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    convenience init?(sharpString: String?, alpha: CGFloat = 1.0) {
        guard let s = sharpString, !s.isEmpty else {
            return nil
        }
        self.init(rgbHexString: s, alpha: alpha)
    }
    
    convenience init?(rgbHexString: String?, alpha: CGFloat = 1.0) {
        var hexSanitized = (rgbHexString ?? "ffffff").trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgbValue) else {
            return nil
        }
        
        self.init(rgbHex: rgbValue, alpha: alpha)
    }
    
    convenience init?(rgbHex: UInt64, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((rgbHex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbHex & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbHex & 0x0000FF) / 255.0,
                  alpha: CGFloat(alpha))
    }
}
