//
//  CalendarView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/28.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

protocol CalendarCellDelegate: AnyObject {
    func selected(date: Date)
}

//MARK: CalendarView
final class CalendarCell: UICollectionViewCell {
    enum CellType: Int, CaseIterable {
        case week = 0
        case day
    }
    //MARK: - Properties
    weak var delegate: CalendarCellDelegate?
    private let calendarView = CalendarView(type: .todo)
    private let viewModel = TodoListViewModel()
    private let todoGuideView = UIView().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 4.0
    }
    private let todoGuideLabel = UILabel().then {
        $0.text = "TODO"
        $0.textColor = .white
        $0.font = .regular(with: 16)
    }
    private let dDayGuideView = UIView().then {
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 4.0
    }
    private let dDayGuideLabel = UILabel().then {
        $0.text = "D-DAY"
        $0.textColor = .white
        $0.font = .regular(with: 16)
    }
    private let lineView = DashView().then {
        $0.backgroundColor = .black
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.addSubview(calendarView)
        contentView.addSubview(dDayGuideLabel)
        contentView.addSubview(dDayGuideView)
        contentView.addSubview(todoGuideLabel)
        contentView.addSubview(todoGuideView)
        contentView.addSubview(lineView)
        
        calendarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(381)
        }
        dDayGuideLabel.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(8)
            $0.right.equalToSuperview().offset(-23)
            $0.height.equalTo(24)
        }
        dDayGuideView.snp.makeConstraints {
            $0.centerY.equalTo(dDayGuideLabel.snp.centerY)
            $0.right.equalTo(dDayGuideLabel.snp.left).offset(-4)
            $0.size.equalTo(8)
        }
        todoGuideLabel.snp.makeConstraints {
            $0.centerY.equalTo(dDayGuideLabel.snp.centerY)
            $0.right.equalTo(dDayGuideView.snp.left).offset(-8)
            $0.height.equalTo(24)
        }
        todoGuideView.snp.makeConstraints {
            $0.centerY.equalTo(dDayGuideLabel.snp.centerY)
            $0.right.equalTo(todoGuideLabel.snp.left).offset(-4)
            $0.size.equalTo(8)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(dDayGuideLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
    }
    
    //MARK: - Functions...
    func configure(date: Date?) {
        let calendarDate = date ?? Date()
        calendarView.delegate = self
        calendarView.configure(with: calendarDate)
    }
}

extension CalendarCell: CalendarViewDelegate {
    func select(date: Date) {
        delegate?.selected(date: date)
    }
    
    func select(startDate: Date?, endDate: Date?) {
        
    }
}
