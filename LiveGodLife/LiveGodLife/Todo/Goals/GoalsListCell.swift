//
//  GoalsListCell.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/30.
//

import Foundation
import UIKit

class GoalsListCell: CommonCell {
    
    var dataModel:GoalsModel? {
        didSet {
            update()
        }
    }
    
    let datelabel = UILabel()
    let mindsetImage = UIImageView()
    let mindsetCountLabel = UILabel()
    let totalTodoCountLabel = UILabel()
    let totalTodoImage = UIImageView()
    let completedTodoCount = UILabel()
    let completedTodoImage = UIImageView()
    let dDayLabel = UILabel()
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let progress = UIProgressView()

    lazy var contentsView:UIView = {
        let view = UIView()
        
        self.datelabel.textColor = .white
        self.mindsetCountLabel.textColor = .white
        self.totalTodoCountLabel.textColor = .white
        self.completedTodoCount.textColor = .white
        self.datelabel.textColor = .white
        
        self.mindsetImage.image = UIImage(named: "mindset")
        self.totalTodoImage.image = UIImage(named: "proceeding")
        self.completedTodoImage.image = UIImage(named: "complete")
        
        
        view.addSubview(self.titleLabel)
        view.addSubview(self.dDayLabel)
        
        view.addSubview(self.mindsetImage)
        view.addSubview(self.mindsetCountLabel)
        view.addSubview(self.totalTodoImage)
        view.addSubview(self.totalTodoCountLabel)
        view.addSubview(self.completedTodoImage)
        view.addSubview(self.completedTodoCount)
        
        view.addSubview(self.progress)

        view.addSubview(self.datelabel)
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalTo(self.dDayLabel.snp.left)
            $0.height.equalTo(30)
        }
        self.dDayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(30)

        }
        
        self.mindsetImage.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }
        self.mindsetCountLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(self.mindsetImage.snp.right).offset(3)
        }
        self.totalTodoImage.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(self.mindsetCountLabel.snp.right).offset(12)
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }
        self.totalTodoCountLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(self.totalTodoImage.snp.right).offset(3)
        }
        self.completedTodoImage.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(self.totalTodoCountLabel.snp.right).offset(12)
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }
        self.completedTodoCount.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(self.completedTodoImage.snp.right).offset(3)
        }
        
        self.progress.snp.makeConstraints {
            $0.top.equalTo(self.mindsetImage.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(16)
        }
        
        self.datelabel.snp.makeConstraints {
            $0.top.equalTo(self.progress.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
        
        
        addViews()
        self.update()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    func addViews() {
        self.addSubview(self.contentsView)
        self.contentsView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }

    func update() {
        titleLabel.text = dataModel?.title ?? "데일리 코딩"
        titleLabel.textColor = .white
        dDayLabel.textColor = .green
        
        let minsetCount = self.dataModel?.totalMindsetCount ?? 0
        mindsetCountLabel.text = "마인드셋:\(minsetCount)"
        let ProceedingCount = self.dataModel?.totalMindsetCount ?? 0
        totalTodoCountLabel.text = "진행중:\(ProceedingCount)"
        let completeCount = self.dataModel?.totalMindsetCount ?? 0
        completedTodoCount.text = "완료:\(completeCount)"
        let startDate = self.dataModel?.startDate ?? (Date.today.date?.toString() ?? "")
        let endDate = self.dataModel?.endDate ?? (Date.today.date?.toString() ?? "")
        datelabel.text = "\(startDate) ~ \(endDate)"
        let dDay = Int(Date.today) ?? 0 - (Int(self.dataModel?.endDate ?? "0") ?? 0)
        let today = Date.today.intValue ?? 0
        let lastDay = self.dataModel?.endDate.intValue ?? 0
        let test = today - lastDay
        dDayLabel.text = "D-\(test)"
    }
    
    override func setUpModel() {
        super.setUpModel()
    }
}
