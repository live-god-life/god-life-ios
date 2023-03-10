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
        $0.layer.cornerRadius = 16
    }
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .semiBold(with: 18)
        $0.textColor = .white
    }
    private let subTitleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .regular(with: 14)
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
        
        innerView.addSubview(titleLabel)
        innerView.addSubview(subTitleLabel)
        innerView.addSubview(completeImageView)
        innerView.addSubview(completeButton)
        
        innerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(56)
            $0.height.equalTo(26)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.equalTo(titleLabel.snp.left)
            $0.height.equalTo(22)
        }
        completeImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        completeButton.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
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
                let isTodo = self.model?.taskType?.uppercased() == "TODO"
                let completedImageName = isTodo ? "btn_toggle_checkbox_on_todo" : "btn_toggle_checkbox_on_dday"
                
                self.completeImageView.image = self.isStatus ? UIImage(named: completedImageName) : UIImage(named: "btn_toggle_checkbox_off")
                self.delegate?.selectedTodo(id: self.model?.todoScheduleId, isCompleted: self.isStatus)
            }
            .store(in: &bag)
    }

    func configure(with todo: SubCalendarModel, completionStatus: Bool) {
        let isTodo = todo.taskType?.uppercased() == "TODO"
        let isCompleted = (todo.completionStatus ?? false) || completionStatus
        let completedImageName = isTodo ? "btn_toggle_checkbox_on_todo" : "btn_toggle_checkbox_on_dday"
        let dDay = todo.todoDay ?? 0
        let dDayString = dDay == 0 ? "D-DAY" : dDay > 0 ? "D+\(dDay)" : "D\(dDay)"
        
        self.model = todo
        self.isStatus = isCompleted
        subTitleLabel.text = isTodo ? repeatString(with: todo.repetitionType, param: todo.repetitionParams) : dDayString
        subTitleLabel.textColor = isTodo ? .green : .blue
        titleLabel.text = todo.title
        completeImageView.image = isCompleted ? UIImage(named: completedImageName) : UIImage(named: "btn_toggle_checkbox_off")
    }
    
    private func repeatString(with type: String?, param: [String]?) -> String {
        if type == "DAY" {
            return "매일"
        } else if type == "WEEK",
                  let parameters = param {
            if parameters.count == 7 {
                return "매일"
            } else if parameters.count == 2,
                      parameters.contains("토"),
                      parameters.contains("일") {
                return "주말"
            } else if parameters.count == 5,
                      parameters.contains("월"),
                      parameters.contains("화"),
                      parameters.contains("수"),
                      parameters.contains("목"),
                      parameters.contains("금") {
                return "평일"
            } else {
                var subTitle = "매주" + parameters.map { "\($0)," }.joined()
                subTitle.removeLast()
                return subTitle
            }
        } else {
            return "매일"
        }
    }
}
