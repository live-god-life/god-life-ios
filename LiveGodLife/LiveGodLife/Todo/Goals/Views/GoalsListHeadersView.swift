//
//  GoalsListHeadersView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/24.
//

import Then
import SnapKit
import UIKit
//MARK: Todo -> 목표 header
final class GoalsListHeadersView: UICollectionReusableView {
    // MARK: - Properties
    weak var delegate: TodoListHeadersViewDelegate? = nil
    private var logoImageView = UIImageView().then {
        $0.image = UIImage(named: "headerLogo")
    }
    private var titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .montserrat(with: 16, weight: .medium)
    }
    private var statusLabel = UILabel().then {
        $0.text = "전체"
        $0.textColor = .white
        $0.font = .montserrat(with: 16, weight: .medium)
    }
    private var buttonImage = UIImageView().then {
        $0.image = UIImage(named: "arrowBottom")
    }
    private lazy var popupButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        backgroundColor = .black
        
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(statusLabel)
        addSubview(buttonImage)
        addSubview(popupButton)
        
        logoImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.left.equalToSuperview().offset(27.1)
            $0.width.equalTo(9.8)
            $0.height.equalTo(15)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(logoImageView.snp.right).offset(7.1)
            $0.height.equalTo(20)
        }
        statusLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalTo(buttonImage.snp.left).offset(-7)
            $0.height.equalTo(24)
        }
        buttonImage.snp.makeConstraints {
            $0.centerY.equalTo(statusLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-27)
            $0.width.equalTo(10)
            $0.height.equalTo(5)
        }
        popupButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(statusLabel.snp.left)
            $0.right.equalTo(buttonImage.snp.right)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(with title: String?) {
        self.titleLabel.text = title
    }
}
