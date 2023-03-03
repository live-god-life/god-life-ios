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
        smartDashesType = .no
        smartQuotesType = .no
        spellCheckingType = .no
        autocorrectionType = .no
        smartInsertDeleteType = .no
        returnKeyType = .done
        backgroundColor = .clear
        textColor = .white
        borderStyle = .none
        font = .semiBold(with: 18)
        
        let attrString = NSAttributedString(string: "닉네임을 입력해 주세요.",
                                            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.6),
                                                         .font: UIFont.semiBold(with: 18)!])
        attributedPlaceholder = attrString
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor

        self.leftViewMode = .always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.bounds.height))
        self.leftView = paddingView

        self.rightViewMode = .always
        let clearButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: self.bounds.height)))
        clearButton.setImage(UIImage(named: "clear"), for: .normal)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        self.rightView = clearButton
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= 16
        return padding
    }

    //MARK: - Functions...
    @objc
    private func clear() {
        self.text = nil
        self.rightView?.isHidden = true
    }
}
