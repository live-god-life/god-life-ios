//
//  TodoCollectionViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/09.
//

import UIKit

protocol TodoCollectionViewCellDelegate: AnyObject {

    func completeTodo(_ id: Int)
}

final class TodoCollectionViewCell: UICollectionViewCell {

    static let identifier = "TodoCollectionViewCell"

    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var repetitionLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!

    weak var delegate: TodoCollectionViewCellDelegate?

    private var id: Int?

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 51
        checkButton.tintColor = .green
        checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
        contentView.backgroundColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
    }

    func configure(_ todo: Todo.Schedule) {
        id = todo.scheduleID
        if todo.dDay == 0 {
            dDayLabel.text = "D-Day"
        } else {
            dDayLabel.text = "D-\(todo.dDay)"
        }
        repetitionLabel.text = todo.repetitions.joined(separator: ",")
        repetitionLabel.isHidden = todo.repetitions.isEmpty
        contentLabel.text = todo.title
    }

    @IBAction func didTapCheckButton(_ sender: UIButton) {
        guard let id = id else {
            // error handle
            return
        }
        delegate?.completeTodo(id)
    }
}
