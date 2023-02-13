//
//  DeleteItemView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/04.
//

import Then
import SnapKit
import UIKit
//MARK: DeleteItemView
final class DeleteItemView: UIView {
    //MARK: - Properties
    private let logoImageView = UIImageView()
    private let deleteImageView = UIImageView().then {
        $0.image = UIImage(named: "trash")
    }
    let deleteButton = UIButton()
    let titleTextField = UITextField().then {
        $0.textColor = .white
        $0.textAlignment = .left
        $0.font = .bold(with: 16)
        $0.smartDashesType = .no
        $0.smartQuotesType = .no
        $0.spellCheckingType = .no
        $0.autocorrectionType = .no
        $0.smartInsertDeleteType = .no
        $0.returnKeyType = .done
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let attrString = NSAttributedString(string: "제목을 입력해주세요.",
                                            attributes: [.foregroundColor: UIColor.gray2,
                                                         .font: UIFont.bold(with: 16)!])
        $0.attributedPlaceholder = attrString
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        backgroundColor = .clear
        
        addSubview(logoImageView)
        addSubview(deleteImageView)
        addSubview(titleTextField)
        addSubview(deleteButton)
        
        logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.size.equalTo(24)
        }
        deleteImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.size.equalTo(24)
        }
        titleTextField.snp.makeConstraints {
            $0.left.equalTo(logoImageView.snp.right).offset(6)
            $0.right.equalTo(deleteImageView.snp.left).offset(-16)
            $0.centerY.equalToSuperview()
        }
        deleteButton.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(56)
        }
    }
    
    func configure(logo: UIImage?, title: String?) {
        logoImageView.image = logo
        titleTextField.text = title
        
        logoImageView.snp.updateConstraints {
            $0.size.equalTo(logo == nil ? 0 : 24)
        }
    }
}
