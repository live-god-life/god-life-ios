//
//  GoalsHeadersView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/24.
//

import Then
import SnapKit
import UIKit

protocol GoalsHeadersViewDelegate: AnyObject {
    func selectStatus()
}

//MARK: Todo -> 목표 header
final class GoalsHeadersView: UICollectionReusableView {
    // MARK: - Properties
    weak var delegate: GoalsHeadersViewDelegate?
    private var logoImageView = UIImageView().then {
        $0.image = UIImage(named: "headerLogo")
    }
    private var titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .montserrat(with: 16, weight: .semibold)
    }
    private var statusLabel = UILabel().then {
        $0.text = "전체"
        $0.textColor = .white.withAlphaComponent(0.8)
        $0.font = .regular(with: 16)
    }
    private var buttonImage = UIButton().then {
        $0.setImage(UIImage(named: "arrowBottom"), for: .normal)
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
    
    // MARK: - Functions...
    private func makeUI() {
        backgroundColor = .black
        
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(statusLabel)
        addSubview(buttonImage)
        addSubview(popupButton)
        
        logoImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.left.equalToSuperview().offset(23.1)
            $0.width.equalTo(9.8)
            $0.height.equalTo(15)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(statusLabel.snp.centerY)
            $0.left.equalTo(logoImageView.snp.right).offset(7.1)
            $0.height.equalTo(24)
        }
        statusLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.right.equalTo(buttonImage.snp.left).offset(-4)
            $0.height.equalTo(24)
        }
        buttonImage.snp.makeConstraints {
            $0.centerY.equalTo(statusLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-20)
            $0.size.equalTo(16)
        }
        popupButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(statusLabel.snp.left)
            $0.right.equalTo(buttonImage.snp.right)
            $0.bottom.equalToSuperview()
        }
        
        popupButton.addTarget(self, action: #selector(touchedStatus), for: .touchUpInside)
    }
    
    func configure(title: String?, status: Bool?) {
        self.titleLabel.text = title
        
        var statusString = "전체"
        if let status {
            statusString = status ? "완료됨" : "진행중"
        }
        self.statusLabel.text = statusString
    }
    
    @objc
    private func touchedStatus() {
        delegate?.selectStatus()
    }
}
