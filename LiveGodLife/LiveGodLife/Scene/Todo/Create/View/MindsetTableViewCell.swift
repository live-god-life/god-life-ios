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
    private let containerView = UIStackView().then {
        $0.spacing = .zero
        $0.alignment = .fill
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 16.0
    }
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
        $0.textColor = .white.withAlphaComponent(0.8)
        $0.font = .semiBold(with: 18)
        $0.isScrollEnabled = false
        $0.textAlignment = .center
        $0.backgroundColor = .black
        $0.contentInset = .zero
        $0.textContainerInset = UIEdgeInsets(top: 24.0, left: 40.0, bottom: 24.0, right: 40.0)
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
        
        contentView.addSubview(containerView)
        contentView.addSubview(leftImageView)
        contentView.addSubview(rightImageView)
        containerView.addArrangedSubview(textView)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        leftImageView.snp.makeConstraints {
            $0.centerY.equalTo(textView)
            $0.left.equalToSuperview().offset(33)
            $0.width.equalTo(12.73)
            $0.height.equalTo(12.04)
        }
        rightImageView.snp.makeConstraints {
            $0.centerY.equalTo(textView)
            $0.right.equalToSuperview().offset(-33)
            $0.width.equalTo(12.73)
            $0.height.equalTo(12.04)
        }
        
        let gradient = UIImage()
        let gradientColor = UIColor(patternImage: gradient
            .gradientImage(bounds: CGRect(x: 0, y: 0,
                                          width: UIScreen.main.bounds.width - 32,
                                          height: bounds.height), colors: [.green, .blue]))
        containerView.layer.borderColor = gradientColor.cgColor
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
