//
//  CommonNavigationView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/28.
//

import Then
import UIKit
import SnapKit
import Combine
//MARK: CommonNavigationView
final class CommonNavigationView: UIView {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    let leftBarButton = UIButton().then {
        $0.setImage(UIImage(named: "back_btn"), for: .normal)
        $0.setImage(UIImage(named: "back_btn"), for: .highlighted)
    }
    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .semiBold(with: 20)
    }
    let rightBarButton = UIButton().then {
        $0.isHidden = true
        $0.setImage(UIImage(named: "navigation_more_btn"), for: .normal)
        $0.setImage(UIImage(named: "navigation_more_btn"), for: .highlighted)
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
    
    //MARK: - Functions...
    private func makeUI() {
        backgroundColor = .black
        
        addSubview(leftBarButton)
        addSubview(titleLabel)
        addSubview(rightBarButton)
        
        leftBarButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(32)
        }
        rightBarButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(32)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(leftBarButton.snp.centerY)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bind() {
        leftBarButton
            .tapPublisher
            .sink { [weak self] _ in
                UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
            }
            .store(in: &bag)
    }
}
