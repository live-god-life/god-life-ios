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
    //MARK: - Properties
    private var id: Int?
    weak var delegate: TodoCollectionViewCellDelegate?
    
//    @IBOutlet private weak var progressBar: CircularProgressBar!
    @IBOutlet private weak var dDayLabel: UILabel!
    @IBOutlet private weak var repetitionLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var contentHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeUI()
    }
    
    //MARK: - Functions...
    private func makeUI() {
//        progressBar.lineWidth = 5
//        progressBar.gradientColor = [UIColor.green.cgColor, UIColor.green.cgColor]
        layer.cornerRadius = 54
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
        let numberOfLines = UILabel.countLines(font: .semiBold(with: 20)!, text: todo.title, width: UIScreen.main.bounds.width - 32.0)
        contentHeightConstraint.constant = numberOfLines < 2 ? 28 : 56
        
        let rate = (Double(todo.completedCount) / Double(todo.totalCount)) * 100
//        progressBar.value = rate
    }

    @IBAction
    private func didTapCheckButton(_ sneder: UIButton) {
        guard let id else { return }
        delegate?.complete(id: id)
    }
}
