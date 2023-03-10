//
//  EmptyTableViewCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/05.
//

import Then
import SnapKit
import UIKit
//MARK: EmptyTableViewCell
final class EmptyTableViewCell: UITableViewCell {
    //MARK: - Properties
    let titleLabel = UILabel().then {
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.textAlignment = .center
        $0.font = .semiBold(with: 20)
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.backgroundColor = .black
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview().offset(16)
        }
    }
}

