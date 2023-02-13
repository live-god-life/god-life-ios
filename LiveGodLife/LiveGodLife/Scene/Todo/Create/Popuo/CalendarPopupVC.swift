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
    private let years = (2000 ... 2100).map { $0 }
    private let month = (1 ... 12).map { $0 }
    private let calendar = Calendar.current
    private let visualEffectView = CustomVisualEffectView()
    private let containerView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 24.0
    }
    private let pickerContainerView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0.0
    }
    private let titleLabel = UILabel().then {
        $0.text = "목표기간"
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    private let calendarView = CalendarView()
    private let pickerView = UIPickerView()
    private let dayCountLabel = UILabel().then {
        $0.text = "-"
        $0.textColor = .green
        $0.font = .semiBold(with: 20)
    }
    private let completedButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitle("완료", for: .highlighted)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.setTitleColor(.lightGray, for: .highlighted)
        $0.setTitleColor(.black, for: .selected)
        $0.titleLabel?.font = .semiBold(with: 18)
        $0.layer.cornerRadius = 27.0
        $0.backgroundColor = .default
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
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .clear
        
        view.addSubview(visualEffectView)
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(calendarView)
        containerView.addSubview(pickerContainerView)
        containerView.addSubview(dayCountLabel)
        containerView.addSubview(completedButton)
        pickerContainerView.addSubview(pickerView)
        
        visualEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(37)
            $0.height.equalTo(625)
        }
        completedButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(54)
        }
        dayCountLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.bottom.equalTo(completedButton.snp.top).offset(-32)
            $0.height.equalTo(30)
        }
        calendarView.snp.makeConstraints {
            $0.bottom.equalTo(dayCountLabel.snp.top).offset(-17)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(377)
        }
        pickerContainerView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(calendarView)
            $0.height.equalTo(321)
        }
        pickerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(238)
        }
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(calendarView.snp.top)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(44)
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
                guard let self, self.completedButton.isSelected else {
                    let alert = UIAlertController(title: "알림", message: "기간을 선택해주세요.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self?.present(alert, animated: true)
                    return
                }
                self.delegate?.select(startDate: self.startDate, endDate: self.endDate)
                self.dismiss(animated: true)
            }
            .store(in: &bag)
    }
    
    func configure() {
        calendarView.delegate = self
        calendarView.configure(with: self.startDate ?? Date(), startDate: self.startDate, endDate: self.endDate)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .black
        
        let year = calendar.component(.year, from: calendarView.targetDate ?? Date()) - 2000
        let month = calendar.component(.month, from: calendarView.targetDate ?? Date()) - 1
        pickerView.selectRow(year, inComponent: 0, animated: false)
        pickerView.selectRow(month, inComponent: 1, animated: false)
        
        let isSelected = startDate != nil && endDate != nil
        completedButton.isSelected = isSelected
        completedButton.backgroundColor = isSelected ? .green : .default
    }
    
    private func isDate(lhs: Date?, rhs: Date?) -> Bool {
        guard let lhs, let rhs else { return false }
        
        let lhsDateString = lhs.dateString
        let rhsDateString = rhs.dateString
        
        return lhsDateString == rhsDateString
    }
}

extension CalendarPopupVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 101 : 12
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let text = component == 0 ? "\(years[row])년" : "\(month[row])월"
        let lbl = UILabel()
        lbl.text = text
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.font = .semiBold(with: 22)
        return lbl
    }
}

extension CalendarPopupVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let date = calendarView.targetDate else { return }
        
        var components = DateComponents()
        
        let year = years[pickerView.selectedRow(inComponent: 0)]
        let month = month[pickerView.selectedRow(inComponent: 1)]
        
        components.year = year
        components.month = month
        components.day = 1
        
        if year != calendar.component(.year, from: date) || month != calendar.component(.month, from: date) {
            self.calendarView.isEnd = true
            self.calendarView.targetDate = calendar.date(from: components)
        }
        
        if year != calendar.component(.year, from: date) || month != calendar.component(.month, from: date) {
            self.calendarView.isEnd = true
            self.calendarView.targetDate = calendar.date(from: components)
        }
    }
}

extension CalendarPopupVC: CalendarViewDelegate {
    func select(title: Date?) {
        guard let date = title else { return }
        
        let isOpen = self.pickerContainerView.alpha == .zero
        
        let year = calendar.component(.year, from: date) - 2000
        let month = calendar.component(.month, from: date) - 1
        pickerView.selectRow(year, inComponent: 0, animated: false)
        pickerView.selectRow(month, inComponent: 1, animated: false)
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
        let angle: CGFloat = isOpen ? .pi : -.pi * 2
        let tr = CGAffineTransform.identity.rotated(by: angle)
        
        animator.addAnimations { [weak self] in
            self?.pickerContainerView.alpha = isOpen ? 1.0 : .zero
            self?.calendarView.titleImageView.transform = tr
        }
        
        animator.startAnimation()
    }
    
    func select(startDate: Date?, endDate: Date?) {
        guard let startDate, let endDate else {
            self.dayCountLabel.text = "-"
            self.completedButton.isSelected = false
            self.completedButton.backgroundColor = .default
            return
        }
        self.startDate = startDate
        self.endDate = endDate
        
        self.completedButton.isSelected = true
        self.completedButton.backgroundColor = .green
        
        let reulst = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        let day = Int(reulst / 60 / 60 / 24) + 1
        
        self.dayCountLabel.text = "총 \(day)일"
    }
}
