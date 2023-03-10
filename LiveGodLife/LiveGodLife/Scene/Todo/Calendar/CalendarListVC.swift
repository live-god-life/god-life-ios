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
    private let calendar = Calendar.current
    private var currentMonth = Date() {
        didSet { viewModel.input.requestDay.send(currentMonth.yyyyMMdd) }
    }
    private var selectedDate = Date()
    private var dayModel = [MainCalendarModel]() {
        didSet {
            self.calendarCollectionView.reloadData()
        }
    }
    private let dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_KR")
    }
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
        $0.contentInset = UIEdgeInsets(top: 16, left: .zero,
                                       bottom: 88, right: .zero)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarCollectionView.reloadSections(IndexSet(0...0))
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(calendarCollectionView)
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(96)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        dateFormatter.dateFormat = "yyyyMMdd"
        viewModel.input.requestDay.send(dateFormatter.string(from: Date()))
        
        viewModel
            .output
            .requestDay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.dayModel = model
            }
            .store(in: &viewModel.bag)
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarListVC: UICollectionViewDataSource {
    enum SectionType: Int, CaseIterable {
        case calendar = 0
        case dateHeader
        case todo
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = SectionType(rawValue: section) else { return .zero }
        
        switch type {
        case .calendar, .dateHeader:
            return 1
        case .todo:
            return dayModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let type = SectionType(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch type {
        case .calendar:
            let cell: CalendarCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(date: selectedDate)
            return cell
        case .dateHeader:
            let cell: DefaultCell = collectionView.dequeueReusableCell(for: indexPath)
            dateFormatter.dateFormat = "MM월 dd일 EEEE"
            let title = dateFormatter.string(from: selectedDate)
            cell.configure(with: title)
            return cell
        case .todo:
            let cell: DayTodosCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(with: dayModel[indexPath.item])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarListVC: UICollectionViewDelegateFlowLayout {
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 32.0
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let type = SectionType(rawValue: indexPath.section) ?? .dateHeader
        
        switch type {
        case .calendar:
            return CGSize(width: width, height: 426.0)
        case .dateHeader:
            return CGSize(width: width, height: 60.0)
        case .todo:
            if dayModel.isEmpty { return .zero }
            return CGSize(width: width, height: DayTodosCell.height(with: dayModel[indexPath.item]))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        guard SectionType(rawValue: section) == .dateHeader else { return .zero }
        let width = UIScreen.main.bounds.width
        return .init(width: width, height: 24.0)
    }
}

// MARK: - CalendarCellDelegate
extension CalendarListVC: CalendarCellDelegate {
    func selected(date: Date) {
        selectedDate = date
        dateFormatter.dateFormat = "yyyyMMdd"
        viewModel.input.requestDay.send(dateFormatter.string(from: date))
    }
    
    func prev(month: Date) {
        if month.yyyyMM == Date().yyyyMM {
            currentMonth = Date()
        } else {
            currentMonth = month
        }
    }
    
    func next(month: Date) {
        if month.yyyyMM == Date().yyyyMM {
            currentMonth = Date()
        } else {
            currentMonth = month
        }
    }
}

// MARK: - DayTodosCellDelegate
extension CalendarListVC: DayTodosCellDelegate {
    func selectDetail(id: Int) {
        navigationController?.pushViewController(DetailGoalVC(id: id), animated: true)
    }
}
