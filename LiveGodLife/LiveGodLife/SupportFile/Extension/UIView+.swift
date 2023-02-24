//
//  UIView+.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/05.
//

import UIKit

extension UIView {
    func makeBorderGradation(startColor: UIColor, endColor: UIColor, radius: CGFloat) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.bounds

        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(roundedRect: self.bounds.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)), cornerRadius: radius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        self.layer.addSublayer(gradient)
    }
    
    func gesture(_ event: GestureType = .tap) -> GesturePublisher {
        GesturePublisher(view: self, event: event)
    }
    
    func setLineDot(color: String, radius: CGFloat){
        let borderLayer = CAShapeLayer()
        
        borderLayer.strokeColor = UIColor(rgbHexString: color)?.cgColor
        borderLayer.lineDashPattern = [2, 2]
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath

        self.layer.addSublayer(borderLayer)
    }
}
