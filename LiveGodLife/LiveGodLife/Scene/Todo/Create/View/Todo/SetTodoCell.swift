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
    weak var delegate: TodoDelegate?
    private var startDate: Date?
    private var endDate: Date?
    private var days = Set<Int>()
    private let containerView = UIView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .gray5
    }
    private let deleteContainerView = UIView().then {
        $0.backgroundColor = .gray5
    }
    private let deleteItemView = DeleteItemView().then {
        $0.configure(logo: nil, title: nil)
    }
    private let dateItemView = SetTodoItemView().then {
        $0.configure(logo: UIImage(named: "period"), title: "목표 기간", value: "필수")
    }
    private let repeatItemView = SetTodoItemView().then {
        $0.configure(logo: UIImage(named: "repetition"), title: "반복 주기", value: "필수")
    }
    private let alarmItemView = SetTodoItemView().then {
        $0.configure(logo: UIImage(named: "alarm"), title: "알람 설정", value: "선택")
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
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-24)
            $0.height.equalTo(24)
        }
        repeatItemView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(alarmItemView.snp.top).offset(-8)
            $0.height.equalTo(24)
        }
        dateItemView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
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
        
        dateItemView
            .itemButton
            .tapPublisher
            .sink { [weak self] _ in
                let vc = CalendarPopupVC(startDate: self?.startDate, endDate: self?.endDate)
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                UIApplication.topViewController()?.present(vc, animated: true)
            }.store(in: &bag)
        
        repeatItemView
            .itemButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self, let startDate = self.startDate, let endDate = self.endDate else {
                    let alert = UIAlertController(title: "알림", message: "목표 기간을 설정해주세요.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    UIApplication.topViewController()?.present(alert, animated: true)
                    return
                }
                let text = self.repeatItemView.valueLabel.text ?? ""
                var repeatType: RepeatPopupVC.RepeatType
                switch text {
                case "매주 평일":
                    repeatType = .weekday
                case "매주 주말":
                    repeatType = .weekend
                case "매일", "필수":
                    repeatType = .everyday
                default:
                    repeatType = .custom(self.days)
                }
                
                let vc = RepeatPopupVC(type: repeatType, startDate: startDate, endDate: endDate)
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                UIApplication.topViewController()?.present(vc, animated: true)
            }.store(in: &bag)
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
            lineView.isHidden = taskType == .bottomRadius
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

extension SetTodoCell: CalendarPopupVCDelegate {
    func select(startDate: Date?, endDate: Date?) {
        guard let startDate, let endDate else { return }
        
        self.startDate = startDate
        self.endDate = endDate
        
        delegate?.date(for: self, startDate: startDate, endDate: endDate)
        
        dateItemView.valueLabel.text = "\(startDate.dateAndTime1) - \(endDate.dateAndTime1)"
    }
}

extension SetTodoCell: RepeatPopupVCDelegate {
    func select(days: Set<Int>) {
        self.days = days
        let dayString = ["일", "월", "화", "수", "목", "금", "토"]
        let sortedDays = days.map { $0 }.sorted(by: <)
                         
        
        if days.count == 7 {
            repeatItemView.valueLabel.text = "매일"
        } else if days.count == 2,
                  days.contains(1) && days.contains(7) {
            repeatItemView.valueLabel.text = "매주 주말"
        } else if days.count == 5,
                  days.contains(2), days.contains(3), days.contains(4), days.contains(5), days.contains(6) {
            repeatItemView.valueLabel.text = "매주 평일"
        } else {
            let result = sortedDays.reduce("매주 ", { $0 + "\(dayString[$1 - 1]),"})
            let daysString = String(result[result.startIndex..<result.index(before: result.endIndex)])
            repeatItemView.valueLabel.text = daysString
        }
        
        
    }
}
