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
final class CustomVisualEffectView: UIView {
    //MARK: - Properties
    let backgroundButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    //MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        backgroundColor = UIColor(rgbHexString: "#414246")?.withAlphaComponent(0.7)
        
        addSubview(backgroundButton)
        
        backgroundButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
