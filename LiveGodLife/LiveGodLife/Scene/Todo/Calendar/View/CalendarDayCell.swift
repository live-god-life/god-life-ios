//
//  CalendarDayCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/28.
//

import Then
import SnapKit
import UIKit
//MARK: CalendarDayCell
final class CalendarDayCell: UICollectionViewCell {
    //MARK: - Properties
    private(set) var date: Date?
    private let vStackView = UIStackView().then {
        $0.spacing = 3
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .equalCentering
    }
    private let hStackView = UIStackView().then {
        $0.spacing = -1
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalCentering
        $0.isHidden = true
    }
    private let dayLabel = UILabel().then {
        $0.textColor = .gray6
        $0.textAlignment = .center
        $0.font = .montserrat(with: 14, weight: .semibold)
    }
    private let todoGuideView = UIView().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 4.0
        $0.isHidden = true
    }
    private let dDayGuideView = UIView().then {
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 4.0
        $0.isHidden = true
    }
    private let statusLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .semiBold(with: 10)
        $0.isHidden = true
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    override func prepareForReuse() {
        contentView.backgroundColor = .black
        contentView.layer.borderWidth = .zero
        contentView.layer.borderColor = UIColor.black.cgColor
        
        date = nil
        dayLabel.text = nil
        dayLabel.textColor = .gray6
        hStackView.isHidden = true
        statusLabel.isHidden = true
        todoGuideView.isHidden = true
        dDayGuideView.isHidden = true
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.layer.cornerRadius = 12.0
        
        contentView.addSubview(vStackView)
        vStackView.addArrangedSubview(dayLabel)
        vStackView.addArrangedSubview(hStackView)
        hStackView.addArrangedSubview(todoGuideView)
        hStackView.addArrangedSubview(dDayGuideView)
        hStackView.addArrangedSubview(statusLabel)
        
        vStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        dayLabel.snp.makeConstraints {
            $0.height.equalTo(16)
        }
        todoGuideView.snp.makeConstraints {
            $0.size.equalTo(8)
        }
        dDayGuideView.snp.makeConstraints {
            $0.size.equalTo(8)
        }
        statusLabel.snp.makeConstraints {
            $0.height.equalTo(12)
        }
    }
    
    func configure(with date: Date?, day: String?, isTodo: Bool, isDDay: Bool, isSelected: Bool) {
        guard let date, let day, !day.isEmpty else { return }
        
        self.date = date
        dayLabel.text = day
        let isToday = date.yyyyMMdd == Date().yyyyMMdd
        guard !isSelected else {
            dayLabel.textColor = .black
            contentView.backgroundColor = .green
            contentView.layer.borderWidth = .zero
            hStackView.isHidden = false
            todoGuideView.isHidden = true
            dDayGuideView.isHidden = true
            statusLabel.text = "보는중"
            statusLabel.textColor = .gray5
            statusLabel.isHidden = false
            return
        }
        
        contentView.backgroundColor = .black
        dayLabel.textColor = .gray6
        statusLabel.textColor = .black
        
        
        if isTodo || isDDay {
            contentView.backgroundColor = .default
            contentView.layer.borderWidth = 1.0
            contentView.layer.borderColor = UIColor.gray9.cgColor
            
            dayLabel.textColor = .DDDDDD
        }
        
        hStackView.isHidden = !isTodo && !isDDay && !isToday
        statusLabel.isHidden = !isToday
        todoGuideView.isHidden = !isTodo || isToday
        dDayGuideView.isHidden = !isDDay || isToday
        
        if isToday {
            statusLabel.text = "오늘"
            statusLabel.textColor = .white
        }
    }
}
