//
//  TaskTableViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/06.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func selectCompleted(_ cell: TaskTableViewCell, id: Int?, isCompleted: Bool)
}

final class TaskTableViewCell: UITableViewCell {
    //MARK: - Properties
    private var todoSchedule: TodoScheduleViewModel?
    weak var delegate: TaskTableViewCellDelegate?
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var checkButton: TaskCheckButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var statusLabel: PaddingLabel!
    @IBOutlet private weak var completeLabel: PaddingLabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    //MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()

        makeUI()
        checkButton.addTarget(self, action: #selector(didTapCheck), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.todoSchedule = nil
    }

    //MARK: - Functions...
    private func makeUI() {
        selectionStyle = .none
        contentView.backgroundColor = .black
        containerView.layer.cornerRadius = 16
        
        statusLabel.backgroundColor = .gray7
        statusLabel.layer.borderWidth = 1.0
        statusLabel.layer.borderColor = UIColor.gray3.cgColor
        statusLabel.layer.cornerRadius = 13.0
        
        completeLabel.font = .semiBold(with: 14)
        statusLabel.layer.cornerRadius = 13.0
    }

    func configure(_ data: TodoScheduleViewModel, isAfter: Bool, isRepeated: Bool) {
        self.todoSchedule = data
        let color = isRepeated ? UIColor.green : UIColor.blue
        let buttonImage = isRepeated ? "btn_toggle_checkbox_on_todo" : "btn_toggle_checkbox_on_dday"

        completeLabel.backgroundColor = color
        checkButton.configure(selectImage: buttonImage)
        dateLabel.text = data.scheduleDate.yyyyMMdd?.yyMMddE
        statusLabel.text = isAfter ? "예정됨" : "미실천"
        
        let today = Date().timeIntervalSince1970
        let lastDay = data.scheduleDate.toDate()?.timeIntervalSince1970 ?? 0.0
        let dDay = Int((today - lastDay) / 60.0 / 60.0 / 24.0) - 1
        completeLabel.text = isAfter ? "D-\(abs(dDay))" : "완료됨"
        titleLabel.text = data.title
        
        checkButton.isSelected = data.completionStatus
        statusLabel.isHidden = data.completionStatus
        completeLabel.isHidden = !data.completionStatus
    }
    
    @objc
    private func didTapCheck() {
        delegate?.selectCompleted(self, id: todoSchedule?.todoScheduleID, isCompleted: !checkButton.isSelected)
        checkButton.isSelected = !checkButton.isSelected
        statusLabel.isHidden = checkButton.isSelected
        completeLabel.isHidden = !checkButton.isSelected
    }
}
