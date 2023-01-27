//
//  TaskInfoView.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/05.
//

import UIKit

final class TaskInfoView: UIView {
    //MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var periodLabel: UILabel!
    @IBOutlet private weak var repetitionLabel: UILabel!
    @IBOutlet private weak var notificationLabel: UILabel!

    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }

    //MARK: - Functions...
    private func commonInit() {
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
