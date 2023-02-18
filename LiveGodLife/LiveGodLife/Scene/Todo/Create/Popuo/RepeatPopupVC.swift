//
//  RepeatPopupVC.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/26.
//

import Then
import SnapKit
import UIKit
import Combine

protocol RepeatPopupVCDelegate: AnyObject {
    func select(days: Set<Int>)
}

//MARK: DatePopupVC
final class RepeatPopupVC: UIViewController {
    enum RepeatType {
        case everyday
        case weekday
        case weekend
        case custom(Set<Int>)
    }
    //MARK: - Properties
    private var startDate: Date?
    private var endDate: Date?
    weak var delegate: RepeatPopupVCDelegate?
    private var bag = Set<AnyCancellable>()
    @Published private var repeatType: RepeatType = .everyday
    private var days = Set<Int>()
    private let calendar = Calendar.current
    private let visualEffectView = CustomVisualEffectView()
    private let containerView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16.0
        $0.distribution = .fill
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 24.0
    }
    private let pickerContainerView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0.0
    }
    private let titleContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let titleLabel = UILabel().then {
        $0.text = "반복 주기"
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    private let repeatDateStackView = RepeatDateStackView()
    private let repeatWeekStackView = RepeatWeekdayView().then {
        $0.isHidden = true
    }
    private let dayCountContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let dayCountLabel = UILabel().then {
        $0.text = "-"
        $0.textColor = .green
        $0.font = .semiBold(with: 20)
    }
    private let buttonContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitle("취소", for: .highlighted)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.white, for: .highlighted)
        $0.titleLabel?.font = .semiBold(with: 18)
        $0.layer.cornerRadius = 27.0
        $0.backgroundColor = .default
    }
    private let completedButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitle("완료", for: .highlighted)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.black, for: .highlighted)
        $0.titleLabel?.font = .semiBold(with: 18)
        $0.layer.cornerRadius = 27.0
        $0.backgroundColor = .green
    }
    
    //MARK: - Life Cycle
    init(type: RepeatType, startDate: Date? = nil, endDate: Date? = nil) {
        self.repeatType = type
        self.startDate = startDate
        self.endDate = endDate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
        configure()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .clear
        
        let width = UIScreen.main.bounds.width
        let btnWidth = (width - 39) / 2
        let bottomView = UIView()
        
        view.addSubview(visualEffectView)
        view.addSubview(containerView)
        containerView.addArrangedSubview(titleContainerView)
        containerView.addArrangedSubview(repeatDateStackView)
        containerView.addArrangedSubview(repeatWeekStackView)
        containerView.addArrangedSubview(pickerContainerView)
        containerView.addArrangedSubview(dayCountContainerView)
        containerView.addArrangedSubview(buttonContainerView)
        containerView.addArrangedSubview(bottomView)
        
        titleContainerView.addSubview(titleLabel)
        dayCountContainerView.addSubview(dayCountLabel)
        buttonContainerView.addSubview(completedButton)
        buttonContainerView.addSubview(cancelButton)
        
        visualEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        titleContainerView.snp.makeConstraints {
            $0.height.equalTo(68)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.bottom.equalToSuperview()
            $0.height.equalTo(44)
        }
        repeatDateStackView.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        repeatWeekStackView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        dayCountContainerView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        dayCountLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.right.bottom.equalToSuperview()
        }
        buttonContainerView.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        cancelButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(54)
        }
        completedButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(54)
        }
        bottomView.snp.makeConstraints {
            $0.height.equalTo(84)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        visualEffectView
            .backgroundButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &bag)
        
        completedButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                var result = Set<Int>()
                switch self.repeatType {
                case .everyday:
                    (1...7).forEach { result.insert($0) }
                    self.delegate?.select(days: result)
                case .weekday:
                    (2...6).forEach { result.insert($0) }
                    self.delegate?.select(days: result)
                case .weekend:
                    result.insert(1)
                    result.insert(7)
                    self.delegate?.select(days: result)
                case .custom(let days):
                    let dayStrings = ["일", "월", "화", "수", "목", "금", "토"]
                    self.delegate?.select(days: days)
                }
                
                self.dismiss(animated: true)
            }
            .store(in: &bag)
        
        cancelButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &bag)
        
        $repeatType
            .sink { [weak self] type in
                guard let self, let startDate = self.startDate, let endDate = self.endDate else { return }
                var totalDayCount = 0
                var sDay = startDate
                self.repeatWeekStackView.isHidden = true
                
                switch type {
                case .everyday:
                    let result = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
                    totalDayCount = Int(result / 60 / 60 / 24) + 1
                case .weekday:
                    while sDay <= endDate {
                        let isWeekday = (2...6) ~= self.calendar.component(.weekday, from: sDay)
                        if isWeekday { totalDayCount += 1 }
                        sDay.addTimeInterval(86400)
                    }
                case .weekend:
                    while sDay <= endDate {
                        let weekday = self.calendar.component(.weekday, from: sDay)
                        let isWeekday = 1 == weekday || 7 == weekday
                        if isWeekday { totalDayCount += 1 }
                        sDay.addTimeInterval(86400)
                    }
                case .custom(let days):
                    self.repeatWeekStackView.isHidden = false
                    while sDay <= endDate {
                        let weekday = self.calendar.component(.weekday, from: sDay)
                        if days.contains(weekday) { totalDayCount += 1 }
                        sDay.addTimeInterval(86400)
                    }
                }
                
                self.dayCountLabel.text = "총 \(totalDayCount)일"
            }
            .store(in: &bag)
    }
    
    func configure() {
        repeatDateStackView.delegate = self
        repeatDateStackView.configure(type: self.repeatType)
        
        repeatWeekStackView.delegate = self
        if case let .custom(days) = self.repeatType {
            self.days = days
            repeatWeekStackView.isHidden = false
            repeatWeekStackView.configure(days: days)
        } else {
            repeatWeekStackView.isHidden = true
            repeatWeekStackView.configure(days: [])
        }
    }
}

extension RepeatPopupVC: RepeatDateStackViewDelegate {
    func select(repeatType: RepeatType) {
        self.repeatType = repeatType
    }
}

extension RepeatPopupVC: RepeatWeekdayViewDelegate {
    func select(days: Set<Int>) {
        repeatType = .custom(days)
    }
}
