//
//  GoalCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/24.
//

import UIKit

final class GoalCell: UICollectionViewCell {
    enum CellType {
        case list
        case title
    }
    
    //MARK: - Properties
    private let datelabel = UILabel().then {
        $0.font = .regular(with: 14)
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.backgroundColor = .clear
    }
    private let mindsetImageView = UIImageView().then {
        let image = UIImage(named: "mindset")?.withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = .white.withAlphaComponent(0.6)
    }
    private let mindsetCountLabel = UILabel().then {
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .regular(with: 16)
    }
    private let totalTodoImageView = UIImageView().then {
        let image = UIImage(named: "Proceeding")?.withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = .white.withAlphaComponent(0.6)
    }
    private let totalTodoCountLabel = UILabel().then {
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .regular(with: 16)
    }
    private let completedTodoImageView = UIImageView().then {
        let image = UIImage(named: "complete")?.withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = .white.withAlphaComponent(0.6)
    }
    private let completedTodoCountLabel = UILabel().then {
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .regular(with: 16)
    }
    private let dDayLabel = UILabel().then {
        $0.font = .semiBold(with: 14)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
        $0.backgroundColor = .green
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    private let progress = GradientProgressView().then {
        $0.gradientColors = [UIColor.green.cgColor,
                             UIColor.blue.cgColor]
    }
    let contentsView = UIView().then {
        $0.layer.cornerRadius = 16
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions...
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
        dDayLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(26)
            $0.width.equalTo(0)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalTo(dDayLabel.snp.left).offset(-8)
            $0.height.equalTo(28)
        }
        mindsetImageView.snp.makeConstraints {
            $0.centerY.equalTo(mindsetCountLabel.snp.centerY)
            $0.left.equalTo(titleLabel.snp.left)
            $0.size.equalTo(16)
        }
        mindsetCountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(mindsetImageView.snp.right).offset(4)
            $0.height.equalTo(24)
        }
        totalTodoImageView.snp.makeConstraints {
            $0.centerY.equalTo(mindsetCountLabel.snp.centerY)
            $0.left.equalTo(mindsetCountLabel.snp.right).offset(8)
            $0.size.equalTo(16)
        }
        totalTodoCountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(totalTodoImageView.snp.right).offset(4)
            $0.height.equalTo(24)
        }
        completedTodoImageView.snp.makeConstraints {
            $0.centerY.equalTo(mindsetCountLabel.snp.centerY)
            $0.left.equalTo(totalTodoCountLabel.snp.right).offset(8)
            $0.size.equalTo(16)
        }
        completedTodoCountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(completedTodoImageView.snp.right).offset(4)
            $0.height.equalTo(24)
        }
        progress.snp.makeConstraints {
            $0.top.equalTo(self.mindsetCountLabel.snp.bottom).offset(12)
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(dDayLabel.snp.right)
            $0.height.equalTo(8)
        }
        datelabel.snp.makeConstraints {
            $0.top.equalTo(progress.snp.bottom).offset(18)
            $0.left.equalTo(titleLabel.snp.left)
            $0.height.equalTo(22)
        }
    }

    func configure(with data: (some GoalProtocol)?, type: CellType = .list) {
        guard let model = data else { return }
        
        contentsView.backgroundColor = type == .list ? .default : .clear
        contentsView.snp.updateConstraints {
            $0.left.right.equalToSuperview().inset(type == .list ? 16 : 0)
        }
        
        titleLabel.text = model.title
        titleLabel.font = type == .list ? .bold(with: 20) : .bold(with: 26)
        titleLabel.snp.updateConstraints {
            $0.top.equalToSuperview().offset(type == .list ? 20 : 0)
            $0.height.equalTo(type == .list ? 28 : 40)
            $0.left.equalToSuperview().offset(type == .list ? 16 : 20)
        }
        dDayLabel.snp.updateConstraints {
            $0.right.equalToSuperview().offset(type == .list ? -16 : -20)
        }
        progress.snp.updateConstraints {
            $0.top.equalTo(mindsetCountLabel.snp.bottom).offset(type == .list ? 8 : 16)
        }
        datelabel.snp.updateConstraints {
            $0.top.equalTo(progress.snp.bottom).offset(type == .list ? 18 : 12)
        }
        
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
        let dDayString = dDay < 0 ? "D-\(abs(dDay))" : "D+\(dDay)"
        dDayLabel.text = dDayString
        
        dDayLabel.snp.updateConstraints {
            $0.width.equalTo(dDayString.width(font: .semiBold(with: 14)!) + 16.0)
        }
        
        // Progress
        progress.progress = Float(completeCount) / Float(proceedingCount + completeCount)
        progress.layer.cornerRadius = 4.0
    }
}
