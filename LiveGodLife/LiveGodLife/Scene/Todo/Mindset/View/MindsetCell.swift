//
//  MindsetCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/24.
//

import UIKit

final class MindsetCell: UICollectionViewCell {
    // MARK: - Properties
    private let contentsLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .bold(with: 16)
        $0.textAlignment = .center
        $0.textColor = .white
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

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Func
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
                    UIColor(rgbHexString: "#7CFC00")!,
                    UIColor(rgbHexString: "#537CFF")!
                ]
            )
        )
        contentsView.layer.borderColor = gradientColor.cgColor
        
        leftImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(21)
            $0.width.equalTo(12.73)
            $0.height.equalTo(12.04)
        }
        rightImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-21)
            $0.width.equalTo(12.73)
            $0.height.equalTo(12.04)
        }
        contentsLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalTo(leftImageView.snp.right).offset(7)
            $0.right.equalTo(rightImageView.snp.left).offset(-7)
            $0.bottom.equalToSuperview().offset(-24)
        }
    }

    func configure(with mindset: MindSetModel) {
        contentsLabel.text = "\(mindset.content ?? "")"
    }
    
    static func height(with content: String?) -> CGFloat {
        let width = UIScreen.main.bounds.width
        let labelWidth = width - 120.0
        
        return UILabel.textHeight(withWidth: labelWidth,
                                  font: .bold(with: 16)!,
                                  text: content ?? " ") + 48.0
    }
}
