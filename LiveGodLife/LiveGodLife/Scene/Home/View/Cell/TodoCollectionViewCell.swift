//
//  TodoCollectionViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/09.
//

import UIKit

protocol TodoCollectionViewCellDelegate: AnyObject {

    func complete(id: Int)
}

final class TodoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var progressBar: CircularProgressBar!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var repetitionLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!

    private var id: Int?

    weak var delegate: TodoCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        progressBar.lineWidth = 5
        progressBar.gradientColor = [UIColor.green.cgColor, UIColor.green.cgColor]
        layer.cornerRadius = 51
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray3.cgColor
        contentView.backgroundColor = UIColor.default
        checkButton.setImage(UIImage(named: "btn_toggle_checkbox_on_todo"), for: .normal)
    }

    func configure(_ todo: Todo.Schedule) {
        id = todo.scheduleID
        var dDayText = ""
        if todo.dDay == 0 {
            dDayText = "D-Day"
        } else if todo.dDay < 0 {
            dDayText = "D\(todo.dDay)"
        } else {
            dDayText = "D+\(todo.dDay)"
        }
        dDayLabel.text = dDayText
        repetitionLabel.text = todo.repetitions.joined(separator: ",")
        repetitionLabel.isHidden = todo.repetitions.isEmpty
        contentLabel.text = todo.title
        let rate = (Double(todo.completedCount) / Double(todo.totalCount)) * 100
        progressBar.value = rate
    }

    @IBAction func didTapCheckButton(_ sneder: UIButton) {
        guard let id else { return }
        delegate?.complete(id: id)
    }
}
