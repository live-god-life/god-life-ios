//
//  TodoCollectionViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/09.
//

import UIKit

final class TodoCollectionViewCell: UICollectionViewCell {

    static let identifier = "TodoCollectionViewCell"

    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var repetitionLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!

    private var id: Int?

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 51
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
        contentView.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
    }

    func configure(_ todo: Todo.Schedule) {
        id = todo.scheduleID
        let dDayText = todo.dDay == 0 ? "D-Day" : "D-\(todo.dDay)"
        dDayLabel.text = dDayText
        repetitionLabel.text = todo.repetitions.joined(separator: ",")
        repetitionLabel.isHidden = todo.repetitions.isEmpty
        contentLabel.text = todo.title
    }

    @IBAction func didTapCheckButton(_ sneder: UIButton) {

    }
}
