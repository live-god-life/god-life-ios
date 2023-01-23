//
//  TextFieldView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/05.
//

import UIKit

final class TextFieldView: UITextField {
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        textColor = .white
        borderStyle = .none

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = self.frame.height / 2

        self.leftViewMode = .always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.bounds.height))
        self.leftView = paddingView

        self.rightViewMode = .always
        let clearButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: self.bounds.height)))
        clearButton.setImage(UIImage(named: "clear"), for: .normal)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        self.rightView = clearButton
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= 10
        return padding
    }

    //MARK: - Functions...
    @objc
    private func clear() {
        self.text = nil
    }
}
