//
//  SetTodoItemView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/04.
//

import Then
import SnapKit
import UIKit
//MARK: SetTodoItemView
final class SetTodoItemView: UIView {
    //MARK: - Properties
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel().then {
        $0.textColor = .BBBBBB
        $0.font = .regular(with: 14)
    }
    private let valueLabel = UILabel().then {
        $0.textColor = .BBBBBB
        $0.textAlignment = .right
        $0.font = .regular(with: 14)
    }
    private let detailImageView = UIImageView().then {
        $0.image = UIImage(named: "todoDetail")
    }
    let itemButton = UIButton()
    
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
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(detailImageView)
        addSubview(itemButton)
        
        logoImageView.snp.makeConstraints {
            $0.left.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(logoImageView.snp.right).offset(4)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(25)
            $0.height.equalTo(22)
        }
        detailImageView.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        valueLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(4)
            $0.right.equalTo(detailImageView.snp.left).offset(-4)
            $0.height.equalTo(22)
        }
        itemButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(logo: UIImage?, title: String?, value: String?) {
        logoImageView.image = logo
        titleLabel.text = title
        valueLabel.text = value
    }
}
