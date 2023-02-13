//
//  CalendarViewDayCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/24.
//

import Then
import SnapKit
import UIKit
//MARK: CalendarViewDayCell
final class CalendarViewDayCell: UICollectionViewCell {
    //MARK: - Properties
    var date: Date?
    private var startDate: Date?
    private var endDate: Date?
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 10
    }
    private let stackView = UIStackView().then {
        $0.spacing = .zero
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .equalCentering
    }
    private let titleLabel = UILabel().then {
        $0.textColor = UIColor(rgbHexString: "#8D8D93")
        $0.textAlignment = .center
        $0.font = .montserrat(with: 14, weight: .semibold)
    }
    private let subTitleLabel = UILabel().then {
        $0.isHidden = true
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .semiBold(with: 10)
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
        self.containerView.backgroundColor = .clear
        self.titleLabel.text = nil
        self.titleLabel.textColor = UIColor(rgbHexString: "#8D8D93")
        self.subTitleLabel.isHidden = true
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.addSubview(containerView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(with model: CalendarViewModel, startDate: Date?, endDate: Date?) {
        self.date = model.date
        self.startDate = startDate
        self.endDate = endDate
        self.titleLabel.text = model.dateString
        
        if date?.dateString == Date().dateString {
            self.subTitleLabel.isHidden = false
            self.subTitleLabel.text = "오늘"
            self.subTitleLabel.textColor = .green
            self.titleLabel.textColor = .white
        }
        
        self.selected()
    }
    
    func selected() {
        guard let date else { return }
        
        if let startDate, let endDate,
           startDate <= date && date <= endDate {
            self.titleLabel.textColor = .white
            self.containerView.backgroundColor = UIColor(rgbHexString: "#2B2B30")
        }
        
        if let startDate, startDate == date {
            self.containerView.backgroundColor = .green
            self.titleLabel.textColor = .black
            self.subTitleLabel.text = "시작"
            self.subTitleLabel.textColor = .black
            self.subTitleLabel.isHidden = false
        }
        
        if let endDate, endDate == date {
            self.containerView.backgroundColor = .green
            self.titleLabel.textColor = .black
            self.subTitleLabel.text = "종료"
            self.subTitleLabel.textColor = .black
            self.subTitleLabel.isHidden = false
        }
    }
}
