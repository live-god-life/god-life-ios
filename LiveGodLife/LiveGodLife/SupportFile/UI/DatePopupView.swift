//
//  DatePopupView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/20.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

protocol DatePopupViewDelegate: AnyObject {
    func selected(date: Date?)
    func cancelTouched()
}

//MARK: DatePopupView
final class DatePopupView: UIView {
    enum PickerStyle {
        case time
        case date
    }
    
    //MARK: - Properties
    private var style: PickerStyle
    var bag = Set<AnyCancellable>()
    weak var delegate: DatePopupViewDelegate?
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    private let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitle("취소", for: .highlighted)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.white, for: .highlighted)
        $0.backgroundColor = .default
    }
    private let completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitle("완료", for: .highlighted)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.black, for: .highlighted)
        $0.backgroundColor = .green
    }
    private lazy var datePicker = UIDatePicker().then {
        $0.isHidden = true
        $0.datePickerMode = .time
        $0.timeZone = .autoupdatingCurrent
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
    }
    private lazy var pickerView = UIPickerView().then {
        $0.isHidden = true
        $0.delegate = self
        $0.dataSource = self
    }
    private let month = (1...12).map { $0 }
    private let currentYear = Date().month
    private lazy var year = (self.currentYear ... self.currentYear + 100).map { $0 }
    
    //MARK: - Initializer
    init(style: PickerStyle) {
        self.style = style
        
        super.init(frame: .zero)
        
        makeUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        backgroundColor = .black
        
        let buttonWidth = (UIScreen.main.bounds.width - 39) / 2
        
        datePicker.isHidden = !(style == .time)
        pickerView.isHidden = !(style == .date)
        
        addSubview(titleLabel)
        addSubview(datePicker)
        addSubview(pickerView)
        addSubview(cancelButton)
        addSubview(completeButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(39)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(26)
        }
        datePicker.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(31)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(171)
        }
        pickerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(31)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(171)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(32)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(54)
        }
        completeButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(32)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(54)
        }
    }
    
    private func bind() {
        completeButton
            .tapPublisher
            .sink { [weak self] in
                guard self?.style == .date else {
                    self?.delegate?.selected(date: self?.datePicker.date)
                    return
                }
                
                
                var components = DateComponents()
                components.year = self?.pickerView.selectedRow(inComponent: 0)
                components.month = self?.pickerView.selectedRow(inComponent: 1)
                components.day = 1
                self?.delegate?.selected(date: components.date)
            }
            .store(in: &bag)
        
        cancelButton
            .tapPublisher
            .sink { [weak self] in
                self?.delegate?.cancelTouched()
            }
            .store(in: &bag)
    }
}

extension DatePopupView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 100 : 12
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? "\(year[row])년" : "\(month[row])월"
    }
}
