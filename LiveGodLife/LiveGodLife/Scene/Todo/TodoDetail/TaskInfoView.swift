//
//  TaskInfoView.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/05.
//

import UIKit

struct TaskInfoViewModel {

    let title: String
    let period: String
    let repetition: String
    let notification: String

    init(data: TaskViewModel) {
        title = data.title
        self.period = "\(data.startDate) ~ \(data.endDate)"
        switch data.repetitionType {
        case .day:
            repetition = "매일"
        case .week:
            var value = "매주"
            data.repetitionParams.forEach {
                value.append($0)
            }
            repetition = value
        case .month:
            var value = ""
            data.repetitionParams.forEach {
                value.append("\($0)일")
            }
            repetition = value
        case .none:
            repetition = "없음"
        }
        notification = "매일 오전 9시" // TODO: - 0900
    }
}

class TaskInfoView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var repetitionLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        guard let view = Bundle.main.loadNibNamed("TaskInfoView", owner: self)?.first as? UIView else {
            fatalError("not found name of xib")
        }
        view.frame = self.bounds
        addSubview(view)
    }

    func configure(_ viewModel: TaskInfoViewModel) {
        titleLabel.text = viewModel.title
        periodLabel.text = viewModel.period
        repetitionLabel.text = viewModel.repetition
        notificationLabel.text = viewModel.notification
    }
}
