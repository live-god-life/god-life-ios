//
//  FeedDetailContentCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/29.
//

import Then
import SnapKit
import UIKit
//MARK: FeedDetailContentCell
final class FeedDetailContentCell: UITableViewCell {
    //MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.textColor = .white.withAlphaComponent(0.8)
        $0.font = .semiBold(with: 20)
    }
    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .regular(with: 16)
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
        contentView.addSubview(contentLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(28)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(with content: Feed.Content) {
        titleLabel.text = content.title
        contentLabel.attributedText = content.content.lineAndLetterSpacing(font: .regular(with: 16), lineHeight: 26)
    }
}

