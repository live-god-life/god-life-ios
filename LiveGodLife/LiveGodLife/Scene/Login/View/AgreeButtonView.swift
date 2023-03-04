//
//  AgreeButtonView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/05.
//

import Then
import SnapKit
import UIKit
import SwiftUI
import Combine
//MARK: AgreeButtonView
final class AgreeButtonView: UIView {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    let agreeButton = UIButton()
    let agreeImageView = UIImageView().then {
        $0.image = UIImage(named: "empty-checkbox")
    }
    let titleLabel = UILabel().then {
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .regular(with: 16)
    }
    let detailImageView = UIImageView().then {
        $0.image = UIImage(named: "arrow-right")
    }
    @Published var isSelected = false {
        didSet {
            agreeImageView.image = isSelected ? UIImage(named: "fill-checkbox") : UIImage(named: "empty-checkbox")
        }
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        addSubview(agreeImageView)
        addSubview(titleLabel)
        addSubview(detailImageView)
        addSubview(agreeButton)
        
        agreeImageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        agreeButton.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(32)
        }
        detailImageView.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(agreeImageView.snp.right).offset(8)
            $0.right.equalTo(detailImageView.snp.left).offset(-8)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func bind() {
        agreeButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.isSelected.toggle()
            }
            .store(in: &bag)
    }
}
