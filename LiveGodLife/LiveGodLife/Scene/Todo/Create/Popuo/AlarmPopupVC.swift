//
//  AlarmPopupVC.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/27.
//

import Then
import SnapKit
import UIKit
import Combine

protocol AlarmPopupVCDelegate: AnyObject {
    func select(time: Date?, isNotUsed: Bool)
}

//MARK: DatePopupVC
final class AlarmPopupVC: UIViewController {
    //MARK: - Properties
    private var date: Date?
    private var ampm = ["오전", "오후"]
    private var hours = (1...12).map { $0 }
    private var minutes = (0...59).map { $0 }
    private var isNotUsed = false
    weak var delegate: AlarmPopupVCDelegate?
    private var bag = Set<AnyCancellable>()
    private let calendar = Calendar.current
    private let visualEffectView = CustomVisualEffectView()
    private let datePicker = UIPickerView()
    private let containerView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 24.0
    }
    private let titleLabel = UILabel().then {
        $0.text = "알람설정"
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
    private let formatterr = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.dateFormat = "a h:m"
    }
    
    //MARK: - Life Cycle
    init(time: Date?, isNotUsed: Bool) {
        self.date = time
        self.notUsedButton.isSelected = isNotUsed
        self.notUsedImageView.image = isNotUsed ? UIImage(named: "fill-checkbox") : UIImage(named: "empty-checkbox")
        
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
        
        view.addSubview(visualEffectView)
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(notUsedImageView)
        containerView.addSubview(notUsedLabel)
        containerView.addSubview(notUsedButton)
        containerView.addSubview(cancelButton)
        containerView.addSubview(completedButton)
        containerView.addSubview(datePicker)
        
        visualEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.height.equalTo(496)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(44)
        }
        notUsedImageView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(24)
        }
        notUsedLabel.snp.makeConstraints {
            $0.right.equalTo(notUsedImageView.snp.left).offset(-8)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        notUsedButton.snp.makeConstraints {
            $0.left.equalTo(notUsedLabel.snp.left)
            $0.right.equalTo(notUsedImageView.snp.right)
            $0.top.bottom.equalTo(titleLabel)
        }
        cancelButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(54)
        }
        completedButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(btnWidth)
            $0.height.equalTo(54)
        }
        datePicker.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.bottom.equalTo(cancelButton.snp.top).offset(-24)
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
                
                self.delegate?.select(time: self.notUsedButton.isSelected ? nil : self.date,
                                      isNotUsed: self.notUsedButton.isSelected)
                
                self.dismiss(animated: true)
            }
            .store(in: &bag)
        
        cancelButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &bag)
        
        notUsedButton
            .tapPublisher
            .sink { [weak self] _ in
                let isSelected = !(self?.notUsedButton.isSelected ?? false)
                self?.notUsedButton.isSelected = isSelected
                
                self?.notUsedImageView.image = isSelected ? UIImage(named: "fill-checkbox") : UIImage(named: "empty-checkbox")
            }
            .store(in: &bag)
        
        
    }
    
    func configure() {
        datePicker.delegate = self
        datePicker.dataSource = self
        
        guard let date else {
            datePicker.selectRow(0, inComponent: 0, animated: false)
            datePicker.selectRow(7, inComponent: 1, animated: false)
            datePicker.selectRow(30, inComponent: 2, animated: false)
            return
        }
        
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        datePicker.selectRow(date.ahmm.contains("오전") ? 0 : 1, inComponent: 0, animated: false)
        datePicker.selectRow(hours[hour == 0 ? 11 : hour - 1] - 1, inComponent: 1, animated: false)
        datePicker.selectRow(minutes[min], inComponent: 2, animated: false)
    }
}

extension AlarmPopupVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 2 : component == 1 ? 12 : 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let text = component == 0 ? ampm[row] : component == 1 ? "\(hours[row])" : minutes[row] < 10 ? "0\(minutes[row])" : "\(minutes[row])"
        let lbl = UILabel()
        lbl.text = text
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.font = .semiBold(with: 22)
        return lbl
    }
}

extension AlarmPopupVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pm = ampm[pickerView.selectedRow(inComponent: 0)]
        let hour = hours[pickerView.selectedRow(inComponent: 1)]
        let min = minutes[pickerView.selectedRow(inComponent: 2)]
        
        self.date = formatterr.date(from: "\(pm) \(hour):\(min)")
    }
}
