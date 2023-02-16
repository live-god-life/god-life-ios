//
//  RepeatWeekdayView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/26.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

protocol RepeatWeekdayViewDelegate: AnyObject {
    func select(days: Set<Int>)
}

//MARK: RepeatDateStackView
final class RepeatWeekdayView: UIView {
    //MARK: - Properties
    @Published private var days = Set<Int>()
    weak var delegate: RepeatWeekdayViewDelegate?
    private var bag = Set<AnyCancellable>()
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    private let sunButton = UIButton().then {
        $0.setTitle("일", for: .normal)
        $0.setTitle("일", for: .highlighted)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .normal)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .highlighted)
        $0.setTitleColor(.white, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(rgbHexString: "#39393D")?.cgColor
        $0.layer.borderWidth = 1.0
        $0.backgroundColor = .black
        $0.titleLabel?.font = .regular(with: 14)
        $0.tag = 1
    }
    private let monButton = UIButton().then {
        $0.setTitle("월", for: .normal)
        $0.setTitle("월", for: .highlighted)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .normal)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .highlighted)
        $0.setTitleColor(.white, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(rgbHexString: "#39393D")?.cgColor
        $0.layer.borderWidth = 1.0
        $0.backgroundColor = .black
        $0.titleLabel?.font = .regular(with: 14)
        $0.tag = 2
    }
    private let tueButton = UIButton().then {
        $0.setTitle("화", for: .normal)
        $0.setTitle("화", for: .highlighted)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .normal)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .highlighted)
        $0.setTitleColor(.white, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(rgbHexString: "#39393D")?.cgColor
        $0.layer.borderWidth = 1.0
        $0.backgroundColor = .black
        $0.titleLabel?.font = .regular(with: 14)
        $0.tag = 3
    }
    private let wedButton = UIButton().then {
        $0.setTitle("수", for: .normal)
        $0.setTitle("수", for: .highlighted)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .normal)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .highlighted)
        $0.setTitleColor(.white, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(rgbHexString: "#39393D")?.cgColor
        $0.layer.borderWidth = 1.0
        $0.backgroundColor = .black
        $0.titleLabel?.font = .regular(with: 14)
        $0.tag = 4
    }
    private let thuButton = UIButton().then {
        $0.setTitle("목", for: .normal)
        $0.setTitle("목", for: .highlighted)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .normal)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .highlighted)
        $0.setTitleColor(.white, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(rgbHexString: "#39393D")?.cgColor
        $0.layer.borderWidth = 1.0
        $0.backgroundColor = .black
        $0.titleLabel?.font = .regular(with: 14)
        $0.tag = 5
    }
    private let friButton = UIButton().then {
        $0.setTitle("금", for: .normal)
        $0.setTitle("금", for: .highlighted)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .normal)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .highlighted)
        $0.setTitleColor(.white, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(rgbHexString: "#39393D")?.cgColor
        $0.layer.borderWidth = 1.0
        $0.backgroundColor = .black
        $0.titleLabel?.font = .regular(with: 14)
        $0.tag = 6
    }
    private let satButton = UIButton().then {
        $0.setTitle("토", for: .normal)
        $0.setTitle("토", for: .highlighted)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .normal)
        $0.setTitleColor(UIColor(rgbHexString: "#8D8D93"), for: .highlighted)
        $0.setTitleColor(.white, for: .selected)
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor(rgbHexString: "#39393D")?.cgColor
        $0.layer.borderWidth = 1.0
        $0.backgroundColor = .black
        $0.titleLabel?.font = .regular(with: 14)
        $0.tag = 7
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

        addSubview(stackView)
        stackView.addArrangedSubview(sunButton)
        stackView.addArrangedSubview(monButton)
        stackView.addArrangedSubview(tueButton)
        stackView.addArrangedSubview(wedButton)
        stackView.addArrangedSubview(thuButton)
        stackView.addArrangedSubview(friButton)
        stackView.addArrangedSubview(satButton)
        
        stackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview()
            $0.width.equalTo(328)
            $0.height.equalTo(40)
        }
        sunButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        monButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        tueButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        wedButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        thuButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        friButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        satButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
    }
    
    private func bind() {
        monButton
            .tapPublisher
            .map { self.monButton }
            .sink { self.update(sender: $0) }
            .store(in: &bag)
        
        tueButton
            .tapPublisher
            .map { self.tueButton }
            .sink { self.update(sender: $0) }
            .store(in: &bag)
        
        wedButton
            .tapPublisher
            .map { self.wedButton }
            .sink { self.update(sender: $0) }
            .store(in: &bag)
        
        thuButton
            .tapPublisher
            .map { self.thuButton }
            .sink { self.update(sender: $0) }
            .store(in: &bag)
        
        friButton
            .tapPublisher
            .map { self.friButton }
            .sink { self.update(sender: $0) }
            .store(in: &bag)
        
        satButton
            .tapPublisher
            .map { self.satButton }
            .sink { self.update(sender: $0) }
            .store(in: &bag)
        
        sunButton
            .tapPublisher
            .map { self.sunButton }
            .sink { self.update(sender: $0) }
            .store(in: &bag)
    }
    
    func configure(days: Set<Int>) {
        days.forEach {
            if let btn = self.stackView.viewWithTag($0) as? UIButton {
                update(sender: btn)
            }
        }
    }
    
    func update(sender: UIButton) {
        if self.days.contains(sender.tag) {
            self.days.remove(sender.tag)
            sender.isSelected = false
            sender.layer.borderColor = UIColor(rgbHexString: "#39393D")?.cgColor
            sender.titleLabel?.font = .regular(with: 14)
        } else {
            self.days.insert(sender.tag)
            sender.isSelected = true
            sender.layer.borderColor = UIColor.green.cgColor
            sender.titleLabel?.font = .semiBold(with: 14)
        }
        
        self.delegate?.select(days: self.days)
    }
}
