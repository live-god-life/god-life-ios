//
//  MindsetsHeaderView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/24.
//

import UIKit

final class MindsetListHeadersView: UIView {
    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    let detailButton = UIButton().then {
        $0.layer.cornerRadius = 16
        $0.setImage(UIImage(named: "arrowRight"), for: .normal)
        $0.setImage(UIImage(named: "arrowRight"), for: .highlighted)
        $0.backgroundColor = .gray7
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions...
    private func makeUI() {
        backgroundColor = .black
        
        addSubview(titleLabel)
        addSubview(detailButton)
        

        detailButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.size.equalTo(32)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(detailButton.snp.centerY)
            $0.left.equalToSuperview()
            $0.height.equalTo(28)
        }
    }
    
    func configure(with title: String?) {
        titleLabel.text = title
    }
}
