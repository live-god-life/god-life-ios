//
//  SetTodoCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/04.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa
//MARK: SetTodoCell
final class SetTodoCell: UITableViewCell {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    weak var delegate: DeleteCellDelegate?
    private let containerView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .gray5
    }
    private let deleteContainerView = UIView().then {
        $0.backgroundColor = .gray5
    }
    private let deleteItemView = DeleteItemView().then {
        $0.configure(logo: UIImage(named: "checked"), title: nil)
    }
    private let dateItemView = SetTodoItemView().then {
        $0.configure(logo: UIImage(named: "period"), title: "기간", value: "기간 설정(필수)")
    }
    private let repeatItemView = SetTodoItemView().then {
        $0.configure(logo: UIImage(named: "repetition"), title: "반복", value: "반복 설정(선택)")
    }
    private let alarmItemView = SetTodoItemView().then {
        $0.configure(logo: UIImage(named: "alarm"), title: "알람", value: "당일 오전 9시")
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .gray3.withAlphaComponent(0.4)
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
        containerView.addSubview(deleteContainerView)
        containerView.addSubview(lineView)
        containerView.addSubview(alarmItemView)
        containerView.addSubview(repeatItemView)
        containerView.addSubview(dateItemView)
        deleteContainerView.addSubview(deleteItemView)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        deleteContainerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(dateItemView.snp.top).offset(-16)
            $0.height.equalTo(24)
        }
        lineView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        alarmItemView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(44)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-24)
            $0.height.equalTo(24)
        }
        repeatItemView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(44)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(alarmItemView.snp.top).offset(-8)
            $0.height.equalTo(24)
        }
        dateItemView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(44)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(repeatItemView.snp.top).offset(-8)
            $0.height.equalTo(24)
        }
        deleteItemView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
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
    
    func configure(isType type: GoalType, title: String?, startDate: String?, endDate: String?, alram: String?) {
        updateUI(isType: type)
    }
    
    private func updateUI(isType type: GoalType) {
        let bottom: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let all: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                 .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        switch type {
        case .task:
            lineView.isHidden = true
            containerView.layer.borderWidth = 1.0
            containerView.layer.borderColor = UIColor.gray3.cgColor
            containerView.layer.cornerRadius = 16.0
            containerView.layer.maskedCorners = all
            deleteContainerView.backgroundColor = .default
            
            containerView.snp.updateConstraints {
                $0.top.equalToSuperview().offset(16)
            }
            deleteContainerView.snp.updateConstraints {
                $0.height.equalTo(72)
            }
        case .folder(let taskType):
            lineView.isHidden = false
            containerView.layer.borderWidth = 1.0
            containerView.layer.borderColor = UIColor.gray3.cgColor
            containerView.layer.cornerRadius = taskType == .bottomRadius ? 16.0 : .zero
            containerView.layer.maskedCorners = taskType == .bottomRadius ? bottom : all
            deleteContainerView.backgroundColor = .gray5
            
            containerView.snp.updateConstraints {
                $0.top.equalToSuperview()
            }
            deleteContainerView.snp.updateConstraints {
                $0.height.equalTo(24)
            }
        }
    }
}

