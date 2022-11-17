//
//  CalendarCell.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/15.
//

import Foundation
import UIKit

class CalendarCell: CommonCell {
    
    var dataModel:SubGoals? {
        didSet {
            update()
        }
    }
    let titleLabel: UILabel = {
        let label = UILabel()
//        label.font = .title14
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    func addViews(){
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(30)
        }
        self.backgroundColor = .blue
    }

    func update() {
        titleLabel.text = dataModel?.title ?? ""
    }
    override func setUpModel() {
        super.setUpModel()
        dataModel = super.model as? SubGoals ?? SubGoals(title: "", completionStatus: nil, taskType: "", repetitionType: "", totalTodoTaskScheduleCount: 0, completedTodoTaskScheduleCount: 0, todoDay: 0)
    }
}
