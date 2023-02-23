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
    func prevMonth()
    func nextMonth()
    func selected(date: Date?)
}

//MARK: CalendarView
final class CalendarCell: UICollectionViewCell {
    enum CellType: Int, CaseIterable {
        case week = 0
        case day
    }
    //MARK: - Properties
    private let calendarView = CalendarView()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.addSubview(calendarView)
        
        calendarView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(377)
        }
    }
    
    //MARK: - Binding...
    private func bind() {
        
    }
    
    //MARK: - Functions...
}
