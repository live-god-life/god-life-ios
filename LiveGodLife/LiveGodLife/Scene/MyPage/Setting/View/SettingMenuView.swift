//
//  SettingMenuView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/27.
//

import Then
import SnapKit
import UIKit
//MARK: SettingMenuView
final class SettingMenuView: UIView {
    //MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .semiBold(with: 18)
    }
    let accessoryImageView = UIImageView().then {
        $0.image = UIImage(named: "arrow-right")
    }
    let versionLabel = UILabel().then {
        $0.isHidden = true
        $0.textColor = .green
        $0.font = .semiBold(with: 18)
    }
    
    //MARK: - Initializer
    init(title: String?) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        if let infoDic = Bundle.main.infoDictionary,
           let appVersionName = infoDic["CFBundleShortVersionString"] as? String {
            versionLabel.text = "V " + appVersionName
        }
        
        addSubview(titleLabel)
        addSubview(accessoryImageView)
        addSubview(versionLabel)
        
        accessoryImageView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        versionLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
}
