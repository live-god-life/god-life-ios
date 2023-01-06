//
//  GoalCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/24.
//

import UIKit

final class GoalCell: UICollectionViewCell {
    private let datelabel = UILabel().then {
        $0.font = .regular(with: 14)
        $0.textColor = .AAAAAA
        $0.backgroundColor = .clear
    }
    private let mindsetImageView = UIImageView().then {
        $0.image = UIImage(named: "mindset")
    }
    private let mindsetCountLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .medium(with: 14)
    }
    private let totalTodoImageView = UIImageView().then {
        $0.image = UIImage(named: "Proceeding")
    }
    private let totalTodoCountLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .medium(with: 14)
    }
    private let completedTodoImageView = UIImageView().then {
        $0.image = UIImage(named: "complete")
    }
    private let completedTodoCountLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .medium(with: 14)
    }
    private let dDayLabel = UILabel().then {
        $0.font = .bold(with: 12)
        $0.textColor = .black
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 11
        $0.backgroundColor = .green
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .bold(with: 20)
    }
    private let progress = GradientProgressView().then {
        $0.gradientColors = [UIColor.green.cgColor,
                             UIColor.blue.cgColor]
    }
    lazy var contentsView = UIView().then {
        $0.backgroundColor = .default
        $0.layer.cornerRadius = 16
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.borderWidth = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        contentView.addSubview(self.contentsView)
        
        contentsView.addSubview(self.titleLabel)
        contentsView.addSubview(self.dDayLabel)
        contentsView.addSubview(self.mindsetImageView)
        contentsView.addSubview(self.mindsetCountLabel)
        contentsView.addSubview(self.totalTodoImageView)
        contentsView.addSubview(self.totalTodoCountLabel)
        contentsView.addSubview(self.completedTodoImageView)
        contentsView.addSubview(self.completedTodoCountLabel)
        contentsView.addSubview(self.progress)
        contentsView.addSubview(self.datelabel)
        
        contentsView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(30)
        }
        dDayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(22)
        }
        mindsetImageView.snp.makeConstraints {
            $0.centerY.equalTo(mindsetCountLabel.snp.centerY)
            $0.left.equalToSuperview().offset(16)
            $0.size.equalTo(16)
        }
        mindsetCountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(mindsetImageView.snp.right).offset(4)
            $0.height.equalTo(22)
        }
        totalTodoImageView.snp.makeConstraints {
            $0.centerY.equalTo(mindsetCountLabel.snp.centerY)
            $0.left.equalTo(mindsetCountLabel.snp.right).offset(8)
            $0.size.equalTo(16)
        }
        totalTodoCountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(totalTodoImageView.snp.right).offset(4)
            $0.height.equalTo(22)
        }
        completedTodoImageView.snp.makeConstraints {
            $0.centerY.equalTo(mindsetCountLabel.snp.centerY)
            $0.left.equalTo(totalTodoCountLabel.snp.right).offset(8)
            $0.size.equalTo(16)
        }
        completedTodoCountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(completedTodoImageView.snp.right).offset(4)
            $0.height.equalTo(22)
        }
        progress.snp.makeConstraints {
            $0.top.equalTo(self.mindsetImageView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(8)
        }
        datelabel.snp.makeConstraints {
            $0.top.equalTo(progress.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(22)
        }
    }

    func configure(with data: GoalModel?) {
        guard let model = data else { return }
        
        titleLabel.text = model.title ?? "데일리 코딩"
        // CountLabel
        let minsetCount = model.totalMindsetCount ?? 0
        mindsetCountLabel.text = "마인드셋:\(minsetCount)"
        let proceedingCount = model.totalMindsetCount ?? 0
        totalTodoCountLabel.text = "진행중:\(proceedingCount)"
        let completeCount = model.totalMindsetCount ?? 0
        completedTodoCountLabel.text = "완료:\(completeCount)"
        // DateLabel
        let startDate = model.startDate?.toDate()?.toString() ?? (Date.today.date?.toString() ?? "")
        let endDate = model.endDate?.toDate()?.toString() ?? (Date.today.date?.toString() ?? "")
        datelabel.text = "\(startDate) - \(endDate)"
        // D-Day
        let today = Date().timeIntervalSince1970
        let lastDay = model.endDate?.toDate()?.timeIntervalSince1970 ?? 0.0
        let dDay = Int((today - lastDay) / 60.0 / 60.0 / 24.0)
        let dDayString = dDay < 0 ? "  D-\(abs(dDay))  " : "  D+\(dDay)  "
        dDayLabel.text = dDayString
        // Progress
        progress.progress = Float(completeCount) / Float(proceedingCount + completeCount)
        progress.layer.cornerRadius = 4.0
    }
}
