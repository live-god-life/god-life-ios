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
    private var calendarModel = [DayModel]()
    private let today = Date()
    private let calendar = Calendar.current
    private var days = [String]()
    private var daysCountInMonth = 0
    private var weekdayAdding = 0
    private var currentMonth: String?
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
    private lazy var calendarCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        CalendarCell.register($0)
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
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
            .requestCalendar
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.calendarModel = model
                self?.calendarCollectionView.reloadSections(IndexSet(0...0))
            }
            .store(in: &viewModel.bag)
    }
    
    private func calculation() {
        let firstDayOfMonth = calendar.date(from: components) ?? Date()
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        daysCountInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)?.count ?? 0
        weekdayAdding = 2 - firstWeekday
        
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
            .requestCalendar
            .send(firstDayOfMonth.toRequestString())
    }
}

extension CalendarListVC: UICollectionViewDataSource {
    enum CellType: Int, CaseIterable {
        case calendar = 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CalendarCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.delegate = self
        cell.configure(with: calendarModel,
                       components: components,
                       month: currentMonth,
                       days: days)
        return cell
    }
}

extension CalendarListVC: UICollectionViewDelegateFlowLayout {
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 30,
                                               left: .zero,
                                               bottom: 44,
                                               right: .zero)
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
        return CGSize(width: width, height: calendarCellHeight())
    }
}

extension CalendarListVC: CalendarCellDelegate {
    func prevMonth() {
        components.month = (components.month ?? 0) - 1
        calculation()
    }
    
    func nextMonth() {
        components.month = (components.month ?? 0) + 1
        calculation()
    }
}
