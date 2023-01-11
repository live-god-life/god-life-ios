//
//  CircularProgressBar.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/10.
//

import UIKit

// https://huisoo.tistory.com/12
class CircularProgressBar: UIView {

    var lineWidth: CGFloat = 10

    var value: Double? {
        didSet {
            guard let _ = value else { return }
            setProgress(self.bounds)
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let bezierPath = UIBezierPath()

        bezierPath.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.midX - ((lineWidth - 1) / 2), startAngle: 0, endAngle: .pi * 2, clockwise: true)

        bezierPath.lineWidth = 10
        UIColor.default.set()
        bezierPath.stroke()
    }

    func setProgress(_ rect: CGRect) {
        guard let value = self.value else {
            return
        }

        self.subviews.forEach { $0.removeFromSuperview() }
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let bezierPath = UIBezierPath()

        bezierPath.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.midX - (lineWidth / 2), startAngle: 0, endAngle: ((.pi * 2) * (value / 100)), clockwise: true)

        let shapeLayer = CAShapeLayer()

        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineCap = .round

        let color: UIColor = .green

        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth

        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)

        gradientLayer.colors = [UIColor.green.withAlphaComponent(0.1).cgColor,
                                UIColor.green.cgColor]
        gradientLayer.frame = bounds
        gradientLayer.mask = shapeLayer

        self.layer.addSublayer(gradientLayer)
    }
}
