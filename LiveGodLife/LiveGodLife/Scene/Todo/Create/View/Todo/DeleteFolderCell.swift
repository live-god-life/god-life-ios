//
//  DeleteFolderCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/04.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

protocol DeleteFolderCellDelegate: AnyObject {
    func delete(for cell: DeleteFolderCell)
    func title(for text: String)
}

//MARK: DeleteFolderCell
final class DeleteFolderCell: UITableViewCell {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    weak var delegate: DeleteFolderCellDelegate?
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "folder")
    }
    private let deleteImageView = UIImageView().then {
        $0.image = UIImage(named: "trash")
    }
    private let deleteButton = UIButton()
    private let titleTextField = UITextField().then {
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
        let attrString = NSAttributedString(string: "폴더의 제목을 입력해주세요.",
                                            attributes: [.foregroundColor: UIColor.gray2,
                                                         .font: UIFont.bold(with: 16)!])
        $0.attributedPlaceholder = attrString
    }
    
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.backgroundColor = .default
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(deleteImageView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(deleteButton)
        
        logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.size.equalTo(24)
        }
        deleteImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
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
    
    private func bind() {
        titleTextField
            .textPublisher
            .compactMap { $0 }
            .sink { [weak self] text in
                self?.delegate?.title(for: text)
            }
            .store(in: &bag)
        
        deleteButton
            .tapPublisher
            .map { self }
            .sink { [weak self] cell in
                self?.delegate?.delete(for: cell)
            }
            .store(in: &bag)
    }
    
    func configure(logo: UIImage?, title: String?) {
        logoImageView.image = logo
        titleTextField.text = title
    }
}
