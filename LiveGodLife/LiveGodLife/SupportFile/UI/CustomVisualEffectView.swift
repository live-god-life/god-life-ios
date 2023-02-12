//
//  CustomVisualEffectView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/26.
//

import Then
import SnapKit
import UIKit
//MARK: CustomVisualEffectView
final class CustomVisualEffectView: UIVisualEffectView {
    //MARK: - Properties
    let backgroundButton = UIButton()
    
    //MARK: - Initializer
    init() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        
        super.init(effect: blurEffect)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.addSubview(backgroundButton)
        
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
