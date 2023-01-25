//
//  DetailTodosCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/28.
//

import Then
import SnapKit
import UIKit
//MARK: DetailTodosCell
final class DetailTodosCell: UICollectionViewCell {
    //MARK: - Properties
    enum CellType: String {
        case folder
        case task
    }
    enum RadiusType {
        case top
        case center
        case bottom
    }
    private let progress = CircleProgressBar(backgroundCircleColor: .black,
                                             foregroundCircleColor: .green,
                                             startGradientColor: .green,
                                             endGradientColor: .green)
    private let dDayLabel = UILabel().then {
        $0.textAlignment = .center
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .bold(with: 16)
    }
    private let dateLabel = UILabel().then {
        $0.textColor = .BBBBBB
        $0.font = .regular(with: 14)
    }
    private let infoImageView = UIImageView()
    private let innerView = UIView().then {
        $0.layer.masksToBounds = true
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(innerView)
        innerView.addSubview(progress)
        innerView.addSubview(dDayLabel)
        innerView.addSubview(titleLabel)
        innerView.addSubview(dateLabel)
        innerView.addSubview(infoImageView)
        
        innerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        progress.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }
        dDayLabel.snp.makeConstraints {
            $0.center.equalTo(progress)
            $0.height.equalTo(12)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(72)
            $0.height.equalTo(24)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalTo(titleLabel.snp.left)
            $0.height.equalTo(24)
        }
        infoImageView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
    
    func configure(with todo: TodoModel?, type: CellType, radius: [RadiusType] = [.center], infoImage: UIImage?) {
        guard let todo else { return }
        titleLabel.text = todo.title
        let start = todo.startDate?.toDate()?.toString() ?? ""
        let end = todo.endDate?.toDate()?.toString() ?? ""
        dateLabel.text = "\(start) ~ \(end)"
        
        innerView.backgroundColor = type == .task ? .gray5 : .default
        infoImageView.image = infoImage
        
        let isDDay = todo.repetitionType == "NONE"
        let total = todo.totalTodoTaskScheduleCount ?? 0
        let complete = todo.completedTodoTaskScheduleCount ?? 0
        progress.progress = Double(complete) / Double(total)
        progress.isHidden = isDDay
        
        // D-Day
        let today = Date().timeIntervalSince1970
        let lastDay = todo.endDate?.toDate()?.timeIntervalSince1970 ?? 0.0
        let dDay = Int((today - lastDay) / 60.0 / 60.0 / 24.0)
        let dDayString = isDDay ? "D-day" : dDay < 0 ? "D-\(abs(dDay))" : "D+\(dDay)"
        dDayLabel.text = dDayString
        dDayLabel.textColor = isDDay ? .blue : .white
        dDayLabel.font = .montserrat(with: isDDay ? 16 : 12, weight: .bold)
        
        if isDDay {
            dDayLabel.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(11)
                $0.centerY.equalToSuperview()
                $0.height.equalTo(24)
            }
        } else {
            dDayLabel.snp.remakeConstraints {
                $0.center.equalTo(progress)
                $0.height.equalTo(12)
            }
        }
        
        if radius.contains(.top) && radius.contains(.bottom) {
            innerView.layer.cornerRadius = 16
            innerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                             .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if radius.contains(.top) {
            innerView.layer.cornerRadius = 16
            innerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if radius.contains(.bottom) {
            innerView.layer.cornerRadius = 16
            innerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            innerView.layer.cornerRadius = .zero
        }
    }
}
