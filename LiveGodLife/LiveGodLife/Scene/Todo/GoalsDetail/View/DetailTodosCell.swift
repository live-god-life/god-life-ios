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
    private let dDayLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .montserrat(with: 12, weight: .semibold)
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .semiBold(with: 18)
    }
    private let dateLabel = UILabel().then {
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .regular(with: 14)
    }
    private let infoImageView = UIImageView()
    private let lineView = UIView().then {
        $0.backgroundColor = .gray3.withAlphaComponent(0.4)
    }
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
        innerView.addSubview(dDayLabel)
        innerView.addSubview(titleLabel)
        innerView.addSubview(dateLabel)
        innerView.addSubview(infoImageView)
        innerView.addSubview(lineView)
        
        innerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        infoImageView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(70)
            $0.right.equalTo(infoImageView.snp.left).offset(-16)
            $0.height.equalTo(24)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.left.equalTo(titleLabel.snp.left)
            $0.height.equalTo(22)
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
        
        var progress: CircleProgressBar
        if isDDay {
            progress = CircleProgressBar(backgroundCircleColor: .black,
                                                     foregroundCircleColor: .blue,
                                                     startGradientColor: .blue,
                                                     endGradientColor: .blue)
        } else {
            progress = CircleProgressBar(backgroundCircleColor: .black,
                                                     foregroundCircleColor: .green,
                                                     startGradientColor: .green,
                                                     endGradientColor: .green)
        }
        
        innerView.addSubview(progress)
        progress.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }
        dDayLabel.snp.makeConstraints {
            $0.center.equalTo(progress)
            $0.height.equalTo(12)
        }
        
        let total = todo.totalTodoTaskScheduleCount ?? 0
        let complete = todo.completedTodoTaskScheduleCount ?? 0
        let rate = Float(complete) / Float(total)
        progress.progress = CGFloat(rate)
        
        let percentString = (rate * 100).isInfinite || (rate * 100).isNaN ? "0%" : "\(Int(rate * 100))%"
        let attributedString = NSMutableAttributedString(string: percentString)
        dDayLabel.attributedText = attributedString.apply(word: "%",
                                                          attrs: [.font: UIFont.montserrat(with: 8, weight: .semibold)!])
        
        if radius.contains(.top) && radius.contains(.bottom) {
            lineView.isHidden = true
            innerView.layer.cornerRadius = 16
            innerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                             .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if radius.contains(.top) {
            lineView.isHidden = type == .folder
            innerView.layer.cornerRadius = 16
            innerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if radius.contains(.bottom) {
            lineView.isHidden = true
            innerView.layer.cornerRadius = 16
            innerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            innerView.layer.cornerRadius = .zero
        }
    }
}
