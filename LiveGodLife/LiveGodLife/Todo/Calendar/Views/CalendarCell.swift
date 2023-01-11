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

//MARK: CalendarView
final class CalendarCell: UICollectionViewCell {
    enum CellType: Int, CaseIterable {
        case week = 0
        case day
    }
    //MARK: - Properties
    private var model = [DayModel]()
    private var bag = Set<AnyCancellable>()
    private let today = Date()
    private let calendar = Calendar.current
    private let weekend = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    private var days = [String]()
    private var daysCountInMonth = 0
    private var weekdayAdding = 0
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy년 MM월"
    }
    private lazy var components: DateComponents = {
        var comp = DateComponents()
        comp.year = calendar.component(.year, from: today)
        comp.month = calendar.component(.month, from: today)
        comp.day = 1
        return comp
    }()
    private let monthLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .bold(with: 24)
    }
    private let prevButton = UIButton().then {
        $0.setTitle("이전달", for: .normal)
        $0.setTitleColor(UIColor.gray6, for: .normal)
        $0.setTitleColor(UIColor.gray6, for: .highlighted)
        $0.titleLabel?.font = .bold(with: 14)
    }
    private let nextButton = UIButton().then {
        $0.setTitle("다음달", for: .normal)
        $0.setTitleColor(UIColor.DDDDDD, for: .normal)
        $0.setTitleColor(UIColor.DDDDDD, for: .highlighted)
        $0.titleLabel?.font = .bold(with: 14)
        $0.backgroundColor = .default
    }
    private let todoGuideView = UIView().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 4.0
    }
    private let todoGuideLabel = UILabel().then {
        $0.text = "Todo"
        $0.textColor = .white
    }
    private let dDayGuideView = UIView().then {
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 4.0
    }
    private let dDayGuideLabel = UILabel().then {
        $0.text = "D-day"
        $0.textColor = .white
    }
    private let dayFormatter = DateFormatter().then {
        $0.dateFormat = "yyyyMMDD"
    }
    private lazy var calendarCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        CalendarDayCell.register($0)
        CalendarWeekCell.register($0)
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        calculation()
        bind()
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        
        contentView.addSubview(monthLabel)
        contentView.addSubview(prevButton)
        contentView.addSubview(nextButton)
        contentView.addSubview(calendarCollectionView)
        contentView.addSubview(dDayGuideLabel)
        contentView.addSubview(dDayGuideView)
        contentView.addSubview(todoGuideLabel)
        contentView.addSubview(todoGuideView)
        
        nextButton.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.equalTo(61)
            $0.height.equalTo(34)
        }
        prevButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.right.equalTo(nextButton.snp.left).offset(-5)
            $0.width.equalTo(61)
            $0.height.equalTo(34)
        }
        monthLabel.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.left.equalToSuperview()
            $0.height.equalTo(32)
        }
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(nextButton.snp.bottom).offset(9)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(height())
        }
        dDayGuideLabel.snp.makeConstraints {
            $0.top.equalTo(calendarCollectionView.snp.bottom).offset(8)
            $0.right.equalToSuperview().offset(-9)
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
    }
    
    private func calculation() {
        let firstDayOfMonth = calendar.date(from: components) ?? Date()
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        daysCountInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)?.count ?? 0
        weekdayAdding = 2 - firstWeekday
        
        monthLabel.text = dateFormatter.string(from: firstDayOfMonth)
        days.removeAll()
        
        for day in weekdayAdding ... daysCountInMonth {
            if day < 1 {
                days.append(" ")
            } else {
                days.append("\(day)")
            }
        }
        
        calendarCollectionView.reloadData()
    }
    
    private func bind() {
        prevButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.components.month = (self?.components.month ?? 0) - 1
                self?.calculation()
            }
            .store(in: &bag)
        
        nextButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.components.month = (self?.components.month ?? 0) + 1
                self?.calculation()
            }
            .store(in: &bag)
    }
    
    func configure(with days: [DayModel]) {
        
    }
}

extension CalendarView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = CellType(rawValue: section) ?? .day
        
        switch type {
        case .week:
            return 7
        case .day:
            return days.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = CellType(rawValue: indexPath.section) ?? .day
        
        switch type {
        case .week:
            let cell: CalendarWeekCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configure(with: weekend[indexPath.item])
            return cell
        case .day:
            let cell: CalendarDayCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            
            var comp = DateComponents()
            comp.year = components.year
            comp.month = components.month
            comp.day = Int(days[indexPath.item])
            
            if let date = comp.date,
               let dayModel = model.first(where: { $0.date == dayFormatter.string(from: date) }) {
                cell.configure(with: days[indexPath.item],
                               isTodo: (dayModel.todoCount ?? 0) > 0,
                               isDDay: (dayModel.dDayCount ?? 0) > 0)
            } else {
                cell.configure(with: days[indexPath.item], isTodo: false, isDDay: false)
            }
            
            return cell
        }
    }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
    func height() -> CGFloat {
        let width = (UIScreen.main.bounds.width - 96) / 7
        let count = CGFloat(days.count / 7 + 1)
        var height = 20.0
        height += count * width
        height += count * 8
        return height
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.minimumInteritemSpacing = 8.0
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let type = CellType(rawValue: indexPath.section) ?? .day
        
        let width = (UIScreen.main.bounds.width - 96) / 7
        
        switch type {
        case .week:
            return CGSize(width: width, height: 20.0)
        case .day:
            return CGSize(width: width, height: width)
        }
    }
}
