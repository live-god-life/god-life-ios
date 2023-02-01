//
//  CreateTodoCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/04.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

protocol CreateTodoCellDelegate: AnyObject {
    func createTodo(with cell: CreateTodoCell)
}

//MARK: CreateTodoCell
final class CreateTodoCell: UITableViewCell {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    weak var delegate: CreateTodoCellDelegate?
    private let containerView = UIView().then {
        $0.backgroundColor = .gray5
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "add-todo")
    }
    private let titleLabel = UILabel().then {
        $0.text = "Todo 생성"
        $0.textColor = .white
        $0.font = .bold(with: 16)
    }
    private let createButton = UIButton()
    
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
        containerView.addSubview(logoImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(createButton)
        
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(logoImageView.snp.right).offset(6)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
        createButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        createButton
            .tapPublisher
            .map { self }
            .sink { [weak self] cell in
                self?.delegate?.createTodo(with: cell)
            }
            .store(in: &bag)
    }
}

