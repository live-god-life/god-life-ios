//
//  GLButton.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/31.
//

import UIKit

protocol CategoryButtonDelegate: AnyObject {

    func didTapButton(_ sender: CategoryButton)
}

class CategoryButton: UIButton {

    weak var delegate: CategoryButtonDelegate?

    override var isSelected: Bool {
        didSet {
            layer.borderColor = oldValue ? UIColor.gray2.cgColor : UIColor.clear.cgColor
            backgroundColor = oldValue ? .clear : .green
        }
    }

    func configure(title: String) {
        setTitle(title, for: .normal)

        layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray2.cgColor

        setTitleColor(.gray2, for: .normal)
        setTitleColor(.black, for: .selected)

        titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 14)

        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @objc func didTapButton(_ sender: CategoryButton) {
        delegate?.didTapButton(sender)
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += 4 * 2
        contentSize.width += 12 * 2
        return contentSize
    }
}
