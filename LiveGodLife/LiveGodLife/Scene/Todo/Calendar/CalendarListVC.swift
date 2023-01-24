//
//  CalendarListVC.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/28.
//

import Then
import SnapKit
import UIKit
import Combine

//MARK: CalendarListVC
final class CalendarListVC: UIViewController {
    //MARK: - Properties
    private let viewModel = TodoListViewModel()
    private var monthModel = [DayModel]()
    private var dayModel = [MainCalendarModel]()
    private let today = Date()
    private let calendar = Calendar.current
    private var days = [String]()
    private var daysCountInMonth = 0
    private var weekdayAdding = 0
    private var currentMonth: String?
    private var selectedDate: Date? = Date()
    private let dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_KR")
    }
    private lazy var components: DateComponents = {
        var comp = DateComponents()
        comp.year = calendar.component(.year, from: today)
        comp.month = calendar.component(.month, from: today)
        comp.day = 1
        return comp
    }()
    private lazy var calendarCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = true
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 30, left: .zero,
                                       bottom: 132, right: .zero)
        DefaultCell.register($0)
        CalendarCell.register($0)
        DayTodosCell.register($0)
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        makeUI()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(calendarCollectionView)
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(116)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        calculation()
        
        viewModel
            .output
            .requestMonth
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.monthModel = model
                self?.calendarCollectionView.reloadSections(IndexSet(0...0))
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestDay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.dayModel = model
                self?.calendarCollectionView.reloadSections(IndexSet(1...2))
            }
            .store(in: &viewModel.bag)
    }
    
    private func calculation() {
        self.dayModel = []
        self.selectedDate = nil
        let firstDayOfMonth = calendar.date(from: components) ?? Date()
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        daysCountInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)?.count ?? 0
        weekdayAdding = 2 - firstWeekday
        
        dateFormatter.dateFormat = "yyyy년 MM월"
        currentMonth = dateFormatter.string(from: firstDayOfMonth)
        days.removeAll()
        
        for day in weekdayAdding ... daysCountInMonth {
            if day < 1 {
                days.append("")
            } else {
                days.append("\(day)")
            }
        }
        
        viewModel
            .input
            .requestMonth
            .send(firstDayOfMonth.toRequestString())
    }
}

extension CalendarListVC: UICollectionViewDataSource {
    enum CellType: Int, CaseIterable {
        case calendar = 0
        case dateHeader
        case todo
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = CellType(rawValue: section) else { return .zero }
        
        switch type {
        case .calendar, .dateHeader:
            return 1
        case .todo:
            return dayModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let type = CellType(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch type {
        case .calendar:
            let cell: CalendarCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(with: monthModel,
                           components: components,
                           month: currentMonth,
                           days: days,
                           selectedDay: selectedDate)
            return cell
        case .dateHeader:
            let cell: DefaultCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = ""
            if let date = selectedDate {
                dateFormatter.dateFormat = "MM월 dd일 EEEE"
                cell.titleLabel.text = dateFormatter.string(from: date)
            }
            cell.titleLabel.isHidden = false
            cell.contentView.backgroundColor = .black
            return cell
        case .todo:
            let cell: DayTodosCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(with: dayModel[indexPath.item])
            return cell
        }
    }
}

extension CalendarListVC: UICollectionViewDelegateFlowLayout {
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 32.0
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    func calendarCellHeight() -> CGFloat {
        let width = (UIScreen.main.bounds.width - 96) / 7
        let count = CGFloat(days.count / 7 + 1)
        var height = 112.0
        height += count * width
        height += count * 8
        return height
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let type = CellType(rawValue: indexPath.section) ?? .dateHeader
        
        switch type {
        case .calendar:
            return CGSize(width: width, height: calendarCellHeight())
        case .dateHeader:
            return CGSize(width: width, height: 61.0)
        case .todo:
            if dayModel.isEmpty { return .zero }
            return CGSize(width: width, height: DayTodosCell.height(with: dayModel[indexPath.item]))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        guard CellType(rawValue: section) == .dateHeader else { return .zero }
        let width = UIScreen.main.bounds.width
        return .init(width: width, height: 17.0)
    }
}

extension CalendarListVC: CalendarCellDelegate {
    func selected(date: Date?) {
        guard let date else { return }
        selectedDate = date
        dateFormatter.dateFormat = "yyyyMMdd"
        viewModel.input.requestDay.send(dateFormatter.string(from: date))
    }
    
    func prevMonth() {
        components.month = (components.month ?? 0) - 1
        calculation()
    }
    
    func nextMonth() {
        components.month = (components.month ?? 0) + 1
        calculation()
    }
}

extension CalendarListVC: DayTodosCellDelegate {
    func selectDetail(id: Int) {
        navigationController?.pushViewController(DetailGoalVC(id: id), animated: true)
    }
}
