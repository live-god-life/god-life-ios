//
//  GoalStatusPopupView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/30.
//

import Then
import SnapKit
import UIKit

protocol GoalStatusPopupViewDelegate: AnyObject {
    func selected(status: Bool?)
}

//MARK: GoalStatusPopupView
final class GoalStatusPopupView: UIView {
    enum Status: Int {
        case all = 0
        case ongoing
        case complete
    }
    //MARK: - Properties
    weak var delegate: GoalStatusPopupViewDelegate?
    private var selectedButton: UIButton?
    private let allButton = UIButton().then {
        $0.tag = 0
        $0.setTitle("전체", for: .normal)
        $0.setTitle("전체", for: .highlighted)
        $0.setTitleColor(UIColor.gray2, for: .normal)
        $0.setTitleColor(.white, for: .highlighted)
        $0.setTitleColor(.white, for: .selected)
        $0.titleLabel?.font = .regular(with: 16)
        $0.contentHorizontalAlignment = .left
    }
    private let startButton = UIButton().then {
        $0.tag = 1
        $0.setTitle("진행중", for: .normal)
        $0.setTitle("진행중", for: .highlighted)
        $0.setTitleColor(UIColor.gray2, for: .normal)
        $0.setTitleColor(.white, for: .highlighted)
        $0.setTitleColor(.white, for: .selected)
        $0.titleLabel?.font = .regular(with: 16)
    }
    private let endButton = UIButton().then {
        $0.tag = 2
        $0.setTitle("완료됨", for: .normal)
        $0.setTitle("완료됨", for: .highlighted)
        $0.setTitleColor(UIColor.gray2, for: .normal)
        $0.setTitleColor(.white, for: .highlighted)
        $0.setTitleColor(.white, for: .selected)
        $0.titleLabel?.font = .regular(with: 16)
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
        backgroundColor = .black
        
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray9.cgColor
        
        allButton.isSelected = true
        
        addSubview(allButton)
        addSubview(startButton)
        addSubview(endButton)
        
        allButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(42)
            $0.height.equalTo(24)
        }
        startButton.snp.makeConstraints {
            $0.top.equalTo(allButton.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(42)
            $0.height.equalTo(24)
        }
        endButton.snp.makeConstraints {
            $0.top.equalTo(startButton.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(42)
            $0.height.equalTo(24)
        }
        
        allButton.addTarget(self, action: #selector(touchedButton(sender:)), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(touchedButton(sender:)), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(touchedButton(sender:)), for: .touchUpInside)
        
        selectedButton = allButton
    }
    
    @objc
    private func touchedButton(sender: UIButton) {
        isHidden = true
        
        sender.isSelected = true
        selectedButton?.isSelected = false
        selectedButton = sender
        
        let type = Status(rawValue: sender.tag) ?? .all
        
        switch type {
        case .all:
            delegate?.selected(status: nil)
        case .ongoing:
            delegate?.selected(status: false)
        case .complete:
            delegate?.selected(status: true)
        }
    }
}
