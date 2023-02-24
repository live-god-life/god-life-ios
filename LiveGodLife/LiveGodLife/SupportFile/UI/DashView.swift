//
//  DashView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/03.
//

import Then
import SnapKit
import UIKit
//MARK: DashView
final class DashView: UIView {
    //MARK: - Properties
    private let borderLayer = CAShapeLayer()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        
    }
    
    override func draw(_ rect: CGRect) {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor(rgbHexString: "#434358")?.cgColor
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineDashPattern = [3, 3]
             
        let path = UIBezierPath()
        let point1 = CGPoint(x: rect.minX, y: rect.midY)
        let point2 = CGPoint(x: rect.maxX, y: rect.midY)
             
        path.move(to: point1)
        path.addLine(to: point2)
             
        layer.path = path.cgPath
        self.layer.addSublayer(layer)
    }
}
