//
//  CommonNavigationView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/28.
//

import Then
import SnapKit
import UIKit
//MARK: CommonNavigationView
final class CommonNavigationView: UIView {
    //MARK: - Properties
    let leftBarButton = UIButton().then {
        $0.setImage(UIImage(named: "back_btn"), for: .normal)
        $0.setImage(UIImage(named: "back_btn"), for: .highlighted)
    }
    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .bold(with: 20)
    }
    let rightBarButton = UIButton().then {
        $0.setImage(UIImage(named: "more_btn"), for: .normal)
        $0.setImage(UIImage(named: "more_btn"), for: .highlighted)
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Functions...
    private func makeUI() {
        addSubview(leftBarButton)
        addSubview(titleLabel)
        addSubview(rightBarButton)
        
        leftBarButton.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(16)
            $0.size.equalTo(32)
        }
        rightBarButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-24)
            $0.size.equalTo(32)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(leftBarButton.snp.centerY)
            $0.centerX.equalToSuperview()
        }
    }
}
