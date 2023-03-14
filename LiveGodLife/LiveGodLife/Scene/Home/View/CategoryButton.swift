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

final class CategoryButton: UIButton {
    //MARK: - Properties
    weak var delegate: CategoryButtonDelegate?

    override var isSelected: Bool {
        didSet {
            titleLabel?.font = oldValue ? .regular(with: 16) : .semiBold(with: 16)
            layer.borderColor = oldValue ? UIColor(sharpString: "414147")?.cgColor : UIColor.clear.cgColor
            backgroundColor = oldValue ? .clear : .green
        }
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height = 36.0
        contentSize.width += 32.0
        return contentSize
    }
    
    //MARK: - Functions...
    func configure(title: String) {
        setTitle(title, for: .normal)

        layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(sharpString: "414147")?.cgColor

        setTitleColor(.white.withAlphaComponent(0.6), for: .normal)
        setTitleColor(.black, for: .selected)

        titleLabel?.font = .regular(with: 16)

        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @objc
    private func didTapButton(_ sender: CategoryButton) {
        delegate?.didTapButton(sender)
    }

}
