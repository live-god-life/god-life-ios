//
//  TaskTableViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/06.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    //MARK: - Properties
    @IBOutlet weak var checkButton: TaskCheckButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: PaddingLabel!
    @IBOutlet weak var completeLabel: PaddingLabel!

    //MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()

        makeUI()
        checkButton.addTarget(self, action: #selector(didTapCheck), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // TODO: - UI
    }

    override func layoutSubviews() {
      super.layoutSubviews()
        
      contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }

    //MARK: - Functions...
    private func makeUI() {
        contentView.backgroundColor = .default
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        selectionStyle = .none
        
        titleLabel.font = .bold(with: 16)
        statusLabel.font = .bold(with: 12)
        completeLabel.font = .bold(with: 12)
    }

    func configure(_ data: TodoScheduleViewModel, isRepeated: Bool) {
        let color = isRepeated ? UIColor.green : UIColor.blue
        let buttonImage = isRepeated ? "btn_toggle_checkbox_on_todo" : "btn_toggle_checkbox_on_dday"

        contentView.layer.borderColor = color.cgColor
        statusLabel.backgroundColor = color
        completeLabel.backgroundColor = color
        checkButton.configure(selectImage: buttonImage)
        titleLabel.text = data.title

        if data.completionStatus {
            didTapCheck()
        }
    }
    
    @objc
    private func didTapCheck() {
        checkButton.isSelected = !checkButton.isSelected
        completeLabel.isHidden = checkButton.isSelected ? false : true
    }
}
