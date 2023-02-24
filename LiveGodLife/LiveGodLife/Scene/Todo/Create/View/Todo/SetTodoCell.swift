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

protocol TodoDelegate: AnyObject {
    func delete(for cell: UITableViewCell)
    func title(for cell: UITableViewCell, with text: String)
    func date(for cell: UITableViewCell, startDate: Date, endDate: Date)
    func repeatDate(for cell: UITableViewCell, with days: [String])
    func alaram(for cell: UITableViewCell, with alarm: String?)
}

//MARK: SetTodoCell
final class SetTodoCell: UITableViewCell {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    weak var delegate: TodoDelegate?
    private var startDate: Date?
    private var endDate: Date?
    private var notification: String?
    private var days = Set<Int>() {
        didSet {
            if days.count == 7 {
                self.repeatType = .everyday
            } else if days.count == 2,
                      days.contains(1) && days.contains(7) {
                self.repeatType = .weekend
            } else if days.count == 5, days.contains(2), days.contains(3),
                      days.contains(4) && days.contains(5), days.contains(6) {
                self.repeatType = .weekday
            } else {
                self.repeatType = .custom(self.days)
            }
        }
    }
    private var repeatType: RepeatPopupVC.RepeatType = .everyday {
        didSet {
            switch repeatType {
            case .everyday:
                repeatItemView.valueLabel.text = "매일"
            case .weekday:
                repeatItemView.valueLabel.text = "매주 평일"
            case .weekend:
                repeatItemView.valueLabel.text = "매주 주말"
            case .custom(let set):
                let dayString = ["일", "월", "화", "수", "목", "금", "토"]
                let sortedDays = set.map { $0 }.sorted(by: <)
                let result = sortedDays.reduce("매주 ", { $0 + "\(dayString[$1 - 1]),"})
                let daysString = String(result[result.startIndex..<result.index(before: result.endIndex)])
                repeatItemView.valueLabel.text = daysString
            }
        }
    }
    private var time: Date?
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.startDate = nil
        self.endDate = nil
        self.notification = nil
        self.deleteItemView.titleTextField.text = nil
        self.dateItemView.valueLabel.text = "필수"
        self.repeatItemView.valueLabel.text = "필수"
        self.alarmItemView.valueLabel.text = "선택"
        
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
                
                let vc = RepeatPopupVC(type: self.repeatType, startDate: startDate, endDate: endDate)
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                UIApplication.topViewController()?.present(vc, animated: true)
            }.store(in: &bag)
        
        alarmItemView
            .itemButton
            .tapPublisher
            .sink { [weak self] _ in
                let vc = AlarmPopupVC(time: self?.time, isNotUsed: self?.notification == "")
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                UIApplication.topViewController()?.present(vc, animated: true)
            }.store(in: &bag)
    }
    
    func configure(isType type: GoalType, title: String?, startDate: String?, endDate: String?,
                   alarm: String?, repeatDays: [String]?, notification: String?) {
        updateUI(isType: type)
        
        self.deleteItemView.titleTextField.text = title
        
        if startDate?.isEmpty == false, endDate?.isEmpty == false,
           let startDate = startDate?.yyyyMMdd, let endDate = endDate?.yyyyMMdd {
            self.startDate = startDate
            self.endDate = endDate
            self.dateItemView.valueLabel.text = "\(startDate.dateAndTime1) - \(endDate.dateAndTime1)"
        }
        
        if let repeatDays {
            guard !repeatDays.isEmpty else {
                repeatItemView.valueLabel.text = nil
                return
            }
            var set = Set<Int>()
            (1 ... repeatDays.count).forEach { set.insert($0) }
            self.days = set
        }
        
        if alarm?.isEmpty == false, let timeDate = alarm?.HHmm {
            self.time = timeDate
            self.alarmItemView.valueLabel.text = timeDate.ahmm
        }
        
        self.notification = notification
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
        let result = days.map { $0 }.sorted(by: <).map { dayString[$0 - 1] }
        delegate?.repeatDate(for: self, with: result)
    }
}

extension SetTodoCell: AlarmPopupVCDelegate {
    func select(time: Date?, isNotUsed: Bool) {
        guard let time else {
            self.alarmItemView.valueLabel.text = "선택"
            self.notification = isNotUsed ? "" : nil
            delegate?.alaram(for: self, with: self.notification)
            return
        }
        
        self.time = time
        self.alarmItemView.valueLabel.text = time.ahmm
        
        delegate?.alaram(for: self, with: time.HHmm)
    }
}
