//
//  RepeatDateStackView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/26.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

protocol RepeatDateStackViewDelegate: AnyObject {
    func select(repeatType: RepeatPopupVC.RepeatType)
}

//MARK: RepeatDateStackView
final class RepeatDateStackView: UIView {
    //MARK: - Properties
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fill
    }
    weak var delegate: RepeatDateStackViewDelegate?
    private var bag = Set<AnyCancellable>()
    private let everyDayButton = UIButton().then {
        $0.setTitle("매일", for: .normal)
        $0.setTitle("매일", for: .highlighted)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .normal)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .highlighted)
        $0.setTitleColor(.black, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(rgbHexString: "#39393D")?.cgColor
        $0.layer.borderWidth = .zero
        $0.backgroundColor = .green
        $0.titleLabel?.font = .semiBold(with: 16)
    }
    private let weekDayButton = UIButton().then {
        $0.setTitle("평일", for: .normal)
        $0.setTitle("평일", for: .highlighted)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .normal)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .highlighted)
        $0.setTitleColor(.black, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(rgbHexString: "#39393D")?.cgColor
        $0.layer.borderWidth = 1.0
        $0.backgroundColor = .black
        $0.titleLabel?.font = .regular(with: 16)
    }
    private let weekendButton = UIButton().then {
        $0.setTitle("주말", for: .normal)
        $0.setTitle("주말", for: .highlighted)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .normal)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .highlighted)
        $0.setTitleColor(.black, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(rgbHexString: "#39393D")?.cgColor
        $0.layer.borderWidth = 1.0
        $0.backgroundColor = .black
        $0.titleLabel?.font = .regular(with: 16)
    }
    private let customButton = UIButton().then {
        $0.setTitle("직접설정", for: .normal)
        $0.setTitle("직접설정", for: .highlighted)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .normal)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .highlighted)
        $0.setTitleColor(.black, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(rgbHexString: "#39393D")?.cgColor
        $0.layer.borderWidth = 1.0
        $0.backgroundColor = .black
        $0.titleLabel?.font = .regular(with: 16)
    }
    lazy var prevButton: UIButton? = self.everyDayButton {
        didSet {
            oldValue?.isSelected = false
            oldValue?.layer.borderWidth = 1.0
            oldValue?.backgroundColor = .black
            oldValue?.titleLabel?.font = .regular(with: 16)
            
            prevButton?.isSelected = true
            prevButton?.backgroundColor = .green
            prevButton?.layer.borderWidth = .zero
            prevButton?.titleLabel?.font = .semiBold(with: 16)
        }
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        backgroundColor = .clear
        
        addSubview(stackView)
        stackView.addArrangedSubview(everyDayButton)
        stackView.addArrangedSubview(weekDayButton)
        stackView.addArrangedSubview(weekendButton)
        stackView.addArrangedSubview(customButton)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(292)
            $0.height.equalTo(36)
        }
        everyDayButton.snp.makeConstraints {
            $0.width.equalTo(60)
        }
        weekDayButton.snp.makeConstraints {
            $0.width.equalTo(60)
        }
        weekendButton.snp.makeConstraints {
            $0.width.equalTo(60)
        }
        customButton.snp.makeConstraints {
            $0.width.equalTo(88)
        }
        
        everyDayButton.isSelected = true
    }
    
    private func bind() {
        everyDayButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.delegate?.select(repeatType: .everyday)
                self?.prevButton = self?.everyDayButton
            }
            .store(in: &bag)
        
        weekDayButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.delegate?.select(repeatType: .weekday)
                self?.prevButton = self?.weekDayButton
            }
            .store(in: &bag)
        
        weekendButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.delegate?.select(repeatType: .weekend)
                self?.prevButton = self?.weekendButton
            }
            .store(in: &bag)
        
        customButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.delegate?.select(repeatType: .custom([]))
                self?.prevButton = self?.customButton
            }
            .store(in: &bag)
    }
    
    func configure(type: RepeatPopupVC.RepeatType) {
        switch type {
        case .everyday:
            prevButton = everyDayButton
        case .weekday:
            prevButton = weekDayButton
        case .weekend:
            prevButton = weekendButton
        case .custom:
            prevButton = customButton
        case .none:
            prevButton = nil
        }
    }
}
