//
//  MindSetTableViewCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/29.
//

import Then
import SnapKit
import UIKit
//MARK: MindSetTableViewCell
final class MindSetTableViewCell: UITableViewCell {
    //MARK: - Properties
    private let contentsLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .semiBold(with: 18)
        $0.textAlignment = .center
        $0.textColor = .white.withAlphaComponent(0.8)
    }
    private let leftImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "leftQuote")
    }
    private let rightImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "rightQuote")
    }
    private let contentsView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 16
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
        backgroundColor = .black
        
        contentView.addSubview(contentsView)
        
        contentsView.addSubview(contentsLabel)
        contentsView.addSubview(leftImageView)
        contentsView.addSubview(rightImageView)
        
        contentsView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        
        let gradient = UIImage()
        let gradientColor = UIColor(patternImage: gradient
            .gradientImage(
                bounds: self.bounds,
                colors: [
                    .green,
                    .blue
                ]
            )
        )
        contentsView.layer.borderColor = gradientColor.cgColor
        
        leftImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(17)
            $0.width.equalTo(12.73)
            $0.height.equalTo(12.04)
        }
        rightImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-17)
            $0.width.equalTo(12.73)
            $0.height.equalTo(12.04)
        }
        contentsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalTo(leftImageView.snp.right).offset(10.27)
            $0.right.equalTo(rightImageView.snp.left).offset(-10.27)
            $0.bottom.equalToSuperview().offset(-24)
        }
    }

    func configure(with mindset: Feed.Mindset) {
        contentsLabel.attributedText = mindset.content.lineAndLetterSpacing(font: .semiBold(with: 18),
                                                                            lineHeight: 26.0,
                                                                            color: .white.withAlphaComponent(0.8))
    }
    
    static func height(with content: String) -> CGFloat {
        let width = UIScreen.main.bounds.width
        let labelWidth = width - 112.0
        let lineCount = content.lineCount(font: .semiBold(with: 18)!, targetWidth: labelWidth)
        
        return 50.0 + (lineCount * 26.0)
    }
}

