//
//  DayTodoCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/29.
//

import UIKit
import Combine
import CombineCocoa

protocol DayTodoCellDelegate: AnyObject {
    func selectedTodo(id: Int?, isCompleted: Bool)
}
final class DayTodoCell: UICollectionViewCell {
    // MARK: - Properties
    weak var delegate: DayTodoCellDelegate?
    private var bag = Set<AnyCancellable>()
    private var model: SubCalendarModel?
    private var isStatus = false
    private let innerView = UIView().then {
        $0.backgroundColor = .default
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 16
    }
    private let typeLabel = UILabel().then {
        $0.font = .montserrat(with: 16, weight: .bold)
    }
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .bold(with: 16)
        $0.textColor = .white
    }
    private let completeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "btn_toggle_checkbox_off")
    }
    private let completeButton = UIButton()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        bind()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Func
    private func makeUI() {
        contentView.addSubview(innerView)
        
        innerView.addSubview(typeLabel)
        innerView.addSubview(titleLabel)
        innerView.addSubview(completeImageView)
        innerView.addSubview(completeButton)
        
        innerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        typeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(72)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
        completeImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-18)
            $0.size.equalTo(20)
        }
        completeButton.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.width.equalTo(56)
        }
    }
    
    private func bind() {
        completeButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                
                self.isStatus.toggle()
                let isTodo = self.model?.taskType == "Todo"
                let completedImageName = isTodo ? "btn_toggle_checkbox_on_todo" : "btn_toggle_checkbox_on_dday"
                let completedColor = isTodo ? UIColor.green.cgColor : UIColor.blue.cgColor
                
                self.innerView.layer.borderColor = self.isStatus ? completedColor : UIColor.gray3.cgColor
                self.completeImageView.image = self.isStatus ? UIImage(named: completedImageName) : UIImage(named: "btn_toggle_checkbox_off")
                self.delegate?.selectedTodo(id: self.model?.todoScheduleId, isCompleted: self.isStatus)
            }
            .store(in: &bag)
    }

    func configure(with todo: SubCalendarModel, completionStatus: Bool) {
        let isTodo = todo.taskType == "Todo"
        let isCompleted = (todo.completionStatus ?? false) || completionStatus
        let completedImageName = isTodo ? "btn_toggle_checkbox_on_todo" : "btn_toggle_checkbox_on_dday"
        let completedColor = isTodo ? UIColor.green.cgColor : UIColor.blue.cgColor
        let dDay = todo.todoDay ?? 0
        let dDayString = dDay == 0 ? "D-day" : dDay > 0 ? "D+\(dDay)" : "D\(dDay)"
        
        self.model = todo
        self.isStatus = isCompleted
        innerView.layer.borderColor = isCompleted ? completedColor : UIColor.gray3.cgColor
        typeLabel.text = isTodo ? "Todo" : dDayString
        typeLabel.textColor = isTodo ? .green : .blue
        titleLabel.text = todo.title
        completeImageView.image = isCompleted ? UIImage(named: completedImageName) : UIImage(named: "btn_toggle_checkbox_off")
    }
}
