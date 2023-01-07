//
//  TaskTableViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/06.
//

import UIKit

class TaskCheckButton: UIButton {

    var selectImage: String = ""

    override var isSelected: Bool {
        didSet {
            setImage(UIImage(named: selectImage), for: .selected)
            setImage(UIImage(named: "btn_toggle_checkbox_off"), for: .normal)
        }
    }

    func configure(selectImage: String) {
        self.selectImage = selectImage
    }
}

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var checkButton: TaskCheckButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: PaddingLabel!
    @IBOutlet weak var completeLabel: PaddingLabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .default
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        selectionStyle = .none

        setupUI()
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

    @objc private func didTapCheck() {
        checkButton.isSelected = !checkButton.isSelected
        completeLabel.isHidden = checkButton.isSelected ? false : true
    }

    func setupUI() {
        titleLabel.font = .bold(with: 16)
        statusLabel.font = .bold(with: 12)
        completeLabel.font = .bold(with: 12)
    }

    func configure(isRepeated: Bool = false) {
        // 반복타입이 없으면 d-day, 아니면 todo: 나중에 모델로 변경하기
        if isRepeated {
            contentView.layer.borderColor = UIColor.green.cgColor
            statusLabel.backgroundColor = .green
            completeLabel.backgroundColor = .green
            checkButton.configure(selectImage: "btn_toggle_checkbox_on_todo")
        } else {
            contentView.layer.borderColor = UIColor.blue.cgColor
            statusLabel.backgroundColor = .blue
            completeLabel.backgroundColor = .blue
            checkButton.configure(selectImage: "btn_toggle_checkbox_on_dday")
        }
    }
}
