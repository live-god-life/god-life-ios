//
//  ProfileView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/11.
//

import Then
import SnapKit
import UIKit
//MARK: ProfileView
final class ProfileView: UIView {
    //MARK: - Properties
    private let profileImageContainerView = UIView().then {
        $0.layer.borderWidth = 2.0
        $0.layer.cornerRadius = 32.0
        let gradient = UIImage()
        let gradientColor = UIColor(patternImage: gradient
            .gradientImage(bounds: CGRect(x: 0, y: 0,
                                          width: 64.0, height: 64.0),
                           colors: [.green, .blue]))
        $0.layer.borderColor = gradientColor.cgColor
        $0.clipsToBounds = true
    }
    var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    var nicknameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    private var subLabel = UILabel().then {
        $0.text = "님"
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    private var infoLabel = UILabel().then {
        $0.text = "프로필 수정"
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .regular(with: 16)
    }
    
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
        addSubview(profileImageContainerView)
        profileImageContainerView.addSubview(profileImageView)
        addSubview(nicknameLabel)
        addSubview(subLabel)
        addSubview(infoLabel)
        
        profileImageContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(64)
        }
        profileImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(32)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(27.5)
            $0.left.equalTo(profileImageContainerView.snp.right).offset(16)
            $0.height.equalTo(29)
        }
        subLabel.snp.makeConstraints {
            $0.centerY.equalTo(nicknameLabel.snp.centerY)
            $0.left.equalTo(nicknameLabel.snp.right).offset(2)
            $0.height.equalTo(29)
        }
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            $0.left.equalTo(profileImageContainerView.snp.right).offset(16)
            $0.right.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
}
