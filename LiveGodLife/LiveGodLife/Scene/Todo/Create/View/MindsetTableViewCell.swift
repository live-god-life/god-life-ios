//
//  MindsetTableViewCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/02.
//

import Then
import SnapKit
import UIKit

protocol MindsetTableViewCellDelegate: AnyObject {
    func updateTextViewHeight(_ cell: MindsetTableViewCell, _ textView: UITextView)
}

//MARK: MindSetCell
final class MindsetTableViewCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: MindsetTableViewCellDelegate?
    private let leftImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "leftQuote")
    }
    private let rightImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "rightQuote")
    }
    lazy var textView = UITextView().then {
        $0.sizeToFit()
        $0.delegate = self
        $0.textColor = .white
        $0.alignTextVertically()
        $0.font = .bold(with: 16)
        $0.isScrollEnabled = false
        $0.textAlignment = .center
        $0.backgroundColor = .black
        $0.contentInset = .zero
        $0.textContainerInset = UIEdgeInsets(top: 24.0, left: 40.0, bottom: 24.0, right: 40.0)
        
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
        $0.layer.borderColor = gradientColor.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 16.0
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
        
        contentView.addSubview(textView)
        contentView.addSubview(leftImageView)
        contentView.addSubview(rightImageView)
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        leftImageView.snp.makeConstraints {
            $0.centerY.equalTo(textView)
            $0.left.equalToSuperview().offset(37)
            $0.width.equalTo(12.73)
            $0.height.equalTo(12.04)
        }
        rightImageView.snp.makeConstraints {
            $0.centerY.equalTo(textView)
            $0.right.equalToSuperview().offset(-37)
            $0.width.equalTo(12.73)
            $0.height.equalTo(12.04)
        }
    }
    
    func configure(with mindset: GoalsMindset?) {
        textView.text = mindset?.content
    }
}

extension MindsetTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.updateTextViewHeight(self, textView)
    }
}
