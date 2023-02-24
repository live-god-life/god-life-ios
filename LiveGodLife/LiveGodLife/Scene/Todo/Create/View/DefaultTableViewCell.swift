//
//  DefaultTableViewCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/02.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

protocol DefaultCellDelegate: AnyObject {
    func selectedAdd(type: CreateAddType)
    func selectedFolder()
}

//MARK: DefaultTableViewCell
final class DefaultTableViewCell: UITableViewCell {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    weak var delegate: DefaultCellDelegate?
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
        $0.isHidden = true
    }
    private let addButton = UIButton().then {
        $0.isHidden = true
        $0.setImage(UIImage(named: "add-todo-folder-plus"), for: .normal)
        $0.setImage(UIImage(named: "add-todo-folder-plus"), for: .highlighted)
        $0.backgroundColor = .default
        $0.layer.cornerRadius = 16.0
    }
    private let folderButton = UIButton().then {
        $0.isHidden = true
        $0.setImage(UIImage(named: "add-folder"), for: .normal)
        $0.setImage(UIImage(named: "add-folder"), for: .highlighted)
        $0.backgroundColor = .default
        $0.layer.cornerRadius = 16.0
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
    
    override func prepareForReuse() {
        titleLabel.text = nil
        addButton.isHidden = true
        titleLabel.isHidden = true
        folderButton.isHidden = true
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(addButton)
        contentView.addSubview(folderButton)
        
        addButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
            $0.size.equalTo(32)
        }
        folderButton.snp.makeConstraints {
            $0.right.equalTo(addButton.snp.left).offset(-8)
            $0.bottom.equalToSuperview()
            $0.size.equalTo(32)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalTo(addButton.snp.centerY)
            $0.height.equalTo(30)
        }
    }
    
    private func bind() {
        addButton
            .tapPublisher
            .map { [weak self] _ in
                self?.titleLabel.text == "TODO"
            }
            .sink { [weak self] isTodo in
                self?.delegate?.selectedAdd(type: isTodo ? .todo : .mindset)
            }
            .store(in: &bag)
        
        folderButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.delegate?.selectedFolder()
            }
            .store(in: &bag)
    }
    
    func configure(with title: String?, isAdd: Bool = false, isFolder: Bool = false) {
        contentView.backgroundColor = .black
        
        titleLabel.text = title
        titleLabel.isHidden = false
        addButton.isHidden = !isAdd
        folderButton.isHidden = !isFolder
    }
}

