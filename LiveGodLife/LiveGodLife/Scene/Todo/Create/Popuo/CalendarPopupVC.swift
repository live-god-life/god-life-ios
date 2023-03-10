//
//  CalendarPopupVC.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/20.
//

import Then
import SnapKit
import UIKit
import Combine

protocol CalendarPopupVCDelegate: AnyObject {
    func select(startDate: Date?, endDate: Date?)
}

//MARK: DatePopupVC
final class CalendarPopupVC: UIViewController {
    //MARK: - Properties
    weak var delegate: CalendarPopupVCDelegate?
    private var startDate: Date?
    private var endDate: Date?
    private var bag = Set<AnyCancellable>()
    private let calendar = Calendar.current
    private let visualEffectView = CustomVisualEffectView()
    private let containerView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 24.0
    }
    private let titleLabel = UILabel().then {
        $0.text = "목표기간"
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    private let closeButton = UIButton()
    private let closeImageButton = UIButton().then {
        $0.setImage(UIImage(named: "calendar-close"), for: .normal)
        $0.setImage(UIImage(named: "calendar-close"), for: .highlighted)
    }
    private let calendarView = CalendarView(type: .date)
    private let dayCountLabel = UILabel().then {
        $0.text = "-"
        $0.textColor = .green
        $0.font = .semiBold(with: 20)
    }
    private let completedButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitle("완료", for: .highlighted)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.white, for: .highlighted)
        $0.setTitleColor(.black, for: .selected)
        $0.titleLabel?.font = .semiBold(with: 18)
        $0.layer.cornerRadius = 27.0
        $0.backgroundColor = .default
    }
    private let startAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
    private let endAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn)
    
    private let lineView = DashView().then {
        $0.backgroundColor = .black
    }
    
    //MARK: - Life Cycle
    init(startDate: Date? = nil, endDate: Date? = nil) {
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
        
        view.addSubview(visualEffectView)
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(calendarView)
        containerView.addSubview(dayCountLabel)
        containerView.addSubview(completedButton)
        containerView.addSubview(closeImageButton)
        containerView.addSubview(closeButton)
        containerView.addSubview(lineView)
        
        visualEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(792)
            $0.height.equalTo(692)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(44)
        }
        closeImageButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(32)
        }
        closeButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(64)
        }
        calendarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(381)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        dayCountLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(30)
        }
        completedButton.snp.makeConstraints {
            $0.top.equalTo(dayCountLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(54)
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
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(792)
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
        
        closeButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.endAnimator.startAnimation()
            }
            .store(in: &bag)
        
        completedButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self, self.completedButton.isSelected else {
                    let alert = UIAlertController(title: "알림", message: "기간을 선택해주세요.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self?.present(alert, animated: true)
                    return
                }
                self.delegate?.select(startDate: self.startDate, endDate: self.endDate)
                self.endAnimator.startAnimation()
            }
            .store(in: &bag)
    }
    
    func configure() {
        calendarView.delegate = self
        calendarView.configure(with: self.startDate ?? Date(), startDate: self.startDate, endDate: self.endDate)
        
        configureDayCountLabel()
    }
    
    private func isDate(lhs: Date?, rhs: Date?) -> Bool {
        guard let lhs, let rhs else { return false }
        
        let lhsDateString = lhs.dateString
        let rhsDateString = rhs.dateString
        
        return lhsDateString == rhsDateString
    }
    
    private func configureDayCountLabel() {
        guard let startDate, let endDate else {
            self.dayCountLabel.text = "-"
            self.completedButton.isSelected = false
            self.completedButton.backgroundColor = .default
            return
        }
        
        self.completedButton.isSelected = true
        self.completedButton.backgroundColor = .green
        
        let reulst = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        let day = Int(reulst / 60 / 60 / 24) + 1
        
        self.dayCountLabel.text = "총 \(day)일"
    }
}

extension CalendarPopupVC: CalendarViewDelegate {
    func select(date: Date) {}
    
    func select(startDate: Date?, endDate: Date?) {
        guard let startDate, let endDate else { return }
        
        self.startDate = startDate
        self.endDate = endDate
        
        configureDayCountLabel()
    }
}
