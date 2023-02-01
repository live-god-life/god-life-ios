//
//  SetTodoCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/04.
//

import Then
import SnapKit
import UIKit
//MARK: SetTodoCell
final class SetTodoCell: UITableViewCell {
    //MARK: - Properties
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.addSubview(lineView)
        contentView.addSubview(alarmItemView)
        contentView.addSubview(repeatItemView)
        contentView.addSubview(dateItemView)
        
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
            $0.bottom.equalTo(alarmItemView.snp.top).offset(-6)
            $0.height.equalTo(24)
        }
        dateItemView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(44)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(repeatItemView.snp.top).offset(-6)
            $0.height.equalTo(24)
        }
    }
}

