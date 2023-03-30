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
    func select(type: String, days: Set<Int>)
}

//MARK: DatePopupVC
final class RepeatPopupVC: UIViewController {
    enum RepeatType {
        case none
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
    private let titleContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let titleLabel = UILabel().then {
        $0.text = "반복 주기"
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    private let notUsedLabel = UILabel().then {
        $0.text = "사용안함"
        $0.textColor = UIColor(rgbHexString: "8D8D93")
        $0.font = .semiBold(with: 16)
    }
    private let notUsedImageView = UIImageView().then {
        $0.image = UIImage(named: "empty-checkbox")
    }
    private let notUsedButton = UIButton()
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
    private let lineContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let lineView = DashView().then {
        $0.backgroundColor = .black
    }
    let startAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
    let endAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn)
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimator.startAnimation()
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
        containerView.addArrangedSubview(lineContainerView)
        containerView.addArrangedSubview(dayCountContainerView)
        containerView.addArrangedSubview(buttonContainerView)
        containerView.addArrangedSubview(bottomView)
        
        titleContainerView.addSubview(titleLabel)
        titleContainerView.addSubview(notUsedImageView)
        titleContainerView.addSubview(notUsedLabel)
        titleContainerView.addSubview(notUsedButton)
        lineContainerView.addSubview(lineView)
        dayCountContainerView.addSubview(dayCountLabel)
        buttonContainerView.addSubview(completedButton)
        buttonContainerView.addSubview(cancelButton)
        
        visualEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(480)
        }
        titleContainerView.snp.makeConstraints {
            $0.height.equalTo(68)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(44)
        }
        notUsedImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-10)
            $0.size.equalTo(24)
        }
        notUsedLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalTo(notUsedImageView.snp.left).offset(-8)
            $0.height.equalTo(26)
        }
        notUsedButton.snp.makeConstraints {
            $0.left.equalTo(notUsedLabel.snp.left)
            $0.verticalEdges.equalToSuperview()
            $0.right.equalToSuperview()
        }
        repeatDateStackView.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        repeatWeekStackView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        lineContainerView.snp.makeConstraints {
            $0.height.equalTo(9)
        }
        lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
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
        
        startAnimator.addAnimations { [weak self] in
            guard let self else { return }
            
            self.containerView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(100)
            }
            self.view.layoutIfNeeded()
        }
        
        endAnimator.addAnimations { [weak self] in
            guard let self else { return }
            
            self.containerView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(480)
            }
            self.view.layoutIfNeeded()
        }
        
        endAnimator.addCompletion { [weak self] _ in
            self?.dismiss(animated: false)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        visualEffectView
            .backgroundButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.endAnimator.startAnimation()
            }
            .store(in: &bag)
        
        notUsedButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                let isSelected = !(self.notUsedButton.isSelected)
                self.notUsedButton.isSelected = isSelected
                self.repeatWeekStackView.isUserInteractionEnabled = !isSelected
                self.repeatDateStackView.isUserInteractionEnabled = !isSelected
                self.notUsedImageView.image = isSelected ? UIImage(named: "fill-checkbox") : UIImage(named: "empty-checkbox")
                
                if isSelected {
                    self.repeatType = .none
                }
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
                    self.delegate?.select(type: "WEEK", days: result)
                case .weekday:
                    (2...6).forEach { result.insert($0) }
                    self.delegate?.select(type: "WEEK", days: result)
                case .weekend:
                    result.insert(1)
                    result.insert(7)
                    self.delegate?.select(type: "WEEK", days: result)
                case .custom(let days):
                    guard !days.isEmpty else {
                        let alert = UIAlertController(title: "알림", message: "반복 날짜를 선택해주세요.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default)
                        alert.addAction(action)
                        self.present(alert, animated: true)
                        return
                    }
                    
                    self.delegate?.select(type: "WEEK", days: days)
                case .none:
                    self.delegate?.select(type: "NONE", days: [])
                    self.endAnimator.startAnimation()
                }
                
                self.endAnimator.startAnimation()
            }
            .store(in: &bag)
        
        cancelButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.endAnimator.startAnimation()
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
                case .none:
                    self.notUsedButton.isSelected = true
                    self.repeatDateStackView.prevButton = nil
                    self.repeatWeekStackView.isHidden = true
                    self.repeatWeekStackView.configure(days: [])
                }
                
                self.dayCountLabel.text = "총 \(totalDayCount)일"
            }
            .store(in: &bag)
    }
    
    func configure() {
        repeatDateStackView.delegate = self
        repeatDateStackView.configure(type: self.repeatType)
        
        repeatWeekStackView.delegate = self
        
        switch repeatType {
        case .custom(let days):
            self.days = days
            repeatWeekStackView.isHidden = false
            repeatWeekStackView.configure(days: days)
        case .none:
            self.notUsedButton.isSelected = true
            self.repeatWeekStackView.isUserInteractionEnabled = false
            self.repeatDateStackView.isUserInteractionEnabled = false
            self.notUsedImageView.image = UIImage(named: "fill-checkbox")
            fallthrough
        default:
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
