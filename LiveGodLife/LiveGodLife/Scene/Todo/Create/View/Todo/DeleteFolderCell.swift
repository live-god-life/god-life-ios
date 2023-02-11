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

protocol TodoDelegate: AnyObject {
    func delete(for cell: UITableViewCell)
    func title(for cell: UITableViewCell, with text: String)
    func date(for cell: UITableViewCell, startDate: Date, endDate: Date)
    func alaram(for cell: UITableViewCell, with repeat: String)
}

//MARK: DeleteFolderCell
final class DeleteFolderCell: UITableViewCell {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    weak var delegate: TodoDelegate?
    private let containerView = UIView().then {
        $0.backgroundColor = .default
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    private let deleteItemView = DeleteItemView().then {
        $0.configure(logo: UIImage(named: "folder"), title: nil)
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
        contentView.backgroundColor = .black
        
        contentView.addSubview(containerView)
        containerView.addSubview(deleteItemView)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        deleteItemView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    
    private func bind() {
        deleteItemView
            .titleTextField
            .textPublisher
            .compactMap { $0 }
            .sink { [weak self] text in
                guard let self else { return }
                self.delegate?.title(for: self, with: text)
            }
            .store(in: &bag)
        
        deleteItemView
            .deleteButton
            .tapPublisher
            .map { self }
            .sink { [weak self] cell in
                self?.delegate?.delete(for: cell)
            }
            .store(in: &bag)
    }
    
    func configure(title: String) {
        deleteItemView.titleTextField.text = title
    }
}
