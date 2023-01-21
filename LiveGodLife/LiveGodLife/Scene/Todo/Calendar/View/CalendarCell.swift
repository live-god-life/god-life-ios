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
    weak var delegate: CalendarCellDelegate?
    var selectedDate: Date? = Date()
    private var selectedIndexPath: IndexPath? {
        didSet {
            guard let oldValue else { return }
            calendarCollectionView.reloadItems(at: [oldValue])
        }
    }
    private var model = [DayModel]()
    private var days = [String]()
    private let calendar = Calendar.current
    private var components = DateComponents()
    private var bag = Set<AnyCancellable>()
    private let weekend = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
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
        $0.layer.cornerRadius = 17.0
        $0.backgroundColor = .default
    }
    private let todoGuideView = UIView().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 4.0
    }
    private let todoGuideLabel = UILabel().then {
        $0.text = "Todo"
        $0.textColor = .white
        $0.font = .medium(with: 16)
    }
    private let dDayGuideView = UIView().then {
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 4.0
    }
    private let dDayGuideLabel = UILabel().then {
        $0.text = "D-day"
        $0.textColor = .white
        $0.font = .medium(with: 16)
    }
    private let dayFormatter = DateFormatter().then {
        $0.dateFormat = "yyyyMMdd"
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .gray4
    }
    
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
        
        contentView.addSubview(monthLabel)
        contentView.addSubview(prevButton)
        contentView.addSubview(nextButton)
        contentView.addSubview(calendarCollectionView)
        contentView.addSubview(dDayGuideLabel)
        contentView.addSubview(dDayGuideView)
        contentView.addSubview(todoGuideLabel)
        contentView.addSubview(todoGuideView)
        contentView.addSubview(lineView)
        
        nextButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().offset(-23)
            $0.width.equalTo(61)
            $0.height.equalTo(34)
        }
        prevButton.snp.makeConstraints {
            $0.centerY.equalTo(nextButton)
            $0.right.equalTo(nextButton.snp.left).offset(-5)
            $0.width.equalTo(61)
            $0.height.equalTo(34)
        }
        monthLabel.snp.makeConstraints {
            $0.centerY.equalTo(nextButton)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(32)
        }
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(nextButton.snp.bottom).offset(9)
            $0.left.equalTo(monthLabel.snp.left)
            $0.right.equalTo(nextButton.snp.right).offset(-1)
        }
        dDayGuideLabel.snp.makeConstraints {
            $0.top.equalTo(calendarCollectionView.snp.bottom).offset(8)
            $0.right.equalToSuperview().offset(-32)
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
            $0.top.equalTo(dDayGuideLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func bind() {
        prevButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.delegate?.prevMonth()
            }
            .store(in: &bag)
        
        nextButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.delegate?.nextMonth()
            }
            .store(in: &bag)
    }
    
    private func isEqual(to d: Date?) -> Bool {
        guard let lhs = selectedDate, let rhs = d else { return false }
        return lhs.toParameterString() == rhs.toParameterString()
    }
    
    func configure(with model: [DayModel],
                   components: DateComponents,
                   month: String?,
                   days: [String],
                   selectedDay: Date?) {
        self.model = model
        self.days = days
        self.components = components
        self.monthLabel.text = month
        self.selectedDate = selectedDay ?? Date()
        
        self.calendarCollectionView.reloadData()
    }
}

extension CalendarCell: UICollectionViewDataSource {
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
            
            let date = calendar.date(from: comp)
            let isEqual = isEqual(to: date)
            if isEqual && selectedIndexPath != indexPath {
                selectedIndexPath = indexPath
                delegate?.selected(date: date)
            }
            var isTodo = false
            var isDDay = false
            
            if days[indexPath.item] != "", let date,
               let dayModel = model.first(where: { $0.date == dayFormatter.string(from: date) }) {
                isTodo = (dayModel.todoCount ?? 0) > 0
                isDDay = (dayModel.dDayCount ?? 0) > 0
            }
            
            cell.configure(with: date,
                           day: days[indexPath.item],
                           isTodo: isTodo,
                           isDDay: isDDay,
                           isSelected: isEqual)
            
            return cell
        }
    }
}

extension CalendarCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarDayCell,
              let selectedDate = cell.date else { return }
        
        self.selectedDate = selectedDate
        self.selectedIndexPath = indexPath
        self.delegate?.selected(date: selectedDate)
        
        collectionView.reloadItems(at: [indexPath])
    }
}

extension CalendarCell: UICollectionViewDelegateFlowLayout {    
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
            return CGSize(width: width, height: 28.0)
        case .day:
            return CGSize(width: width, height: width)
        }
    }
}
