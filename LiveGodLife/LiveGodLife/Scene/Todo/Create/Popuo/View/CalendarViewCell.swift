//
//  CalendarViewCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/24.
//

import Then
import SnapKit
import UIKit

protocol CalendarViewCellDelegate: AnyObject {
    func select(_ cell: CalendarViewCell, dayCell: CalendarViewDayCell)
    func select(_ cell: CalendarViewCell, dayCell: CalendarDayCell)
}

//MARK: CalendarViewCell
final class CalendarViewCell: UICollectionViewCell {
    enum CellType {
        case todo
        case date
    }
    
    //MARK: - Properties
    var type: CellType?
    var startDate: Date?
    var endDate: Date?
    private let viewModel = TodoListViewModel()
    weak var delegate: CalendarViewCellDelegate?
    private var monthModel = [DayModel]() {
        didSet {
            collectionView.collectionViewLayout = setupFlowLayout()
            collectionView.reloadData()
        }
    }
    private var days = [CalendarViewModel]() {
        didSet {
            collectionView.collectionViewLayout = setupFlowLayout()
            collectionView.reloadData()
        }
    }
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        CalendarDayCell.register($0)
        CalendarViewDayCell.register($0)
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel
            .output
            .requestMonth
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.monthModel = model
            }
            .store(in: &viewModel.bag)
    }
    
    func configure(type: CellType, with model: [CalendarViewModel], startDate: Date?, endDate: Date?) {
        self.type = type
        self.days = model
        self.startDate = startDate
        self.endDate = endDate
        
        if let dateString = model.last?.date?.yyyyMM {
            viewModel.input.requestMonth.send(dateString)
        }
    }
    
    func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let width = UIScreen.main.bounds.width - 47
        
        let hSpacing = (width - 280.0) / 6.0
        
        layout.itemSize = .init(width: 40.0, height: 40.0)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = hSpacing
        
        return layout
    }
}

extension CalendarViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = type ?? .date
        let model = days[indexPath.item]
        
        switch type {
        case .todo:
            let cell: CalendarDayCell = collectionView.dequeueReusableCell(for: indexPath)
            
            let day = monthModel.first(where: { $0.date == model.date?.yyyyMMdd })
            let isTodo = (day?.todoCount ?? 0) > 0
            let isDday = (day?.dDayCount ?? 0) > 0
            let isSelected = (model.date?.yyyyMMdd == startDate?.yyyyMMdd) && model.date?.yyyyMMdd != nil
            cell.configure(with: model.date, day: model.dateString, isTodo: isTodo, isDDay: isDday, isSelected: isSelected)
            return cell
        case .date:
            let cell: CalendarViewDayCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: model, startDate: startDate, endDate: endDate)
            return cell
        }
    }
}

extension CalendarViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarViewDayCell {
            delegate?.select(self, dayCell: cell)
        } else if let cell = collectionView.cellForItem(at: indexPath) as? CalendarDayCell {
            delegate?.select(self, dayCell: cell)
            
            let model = days[indexPath.item]
            let day = monthModel.first(where: { $0.date == model.date?.yyyyMMdd })
            
            let isTodo = (day?.todoCount ?? 0) > 0
            let isDday = (day?.dDayCount ?? 0) > 0
            
            cell.configure(with: model.date, day: model.dateString, isTodo: isTodo, isDDay: isDday, isSelected: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CalendarDayCell {
            let model = days[indexPath.item]
            let day = monthModel.first(where: { $0.date == model.date?.yyyyMMdd })
            
            let isTodo = (day?.todoCount ?? 0) > 0
            let isDday = (day?.dDayCount ?? 0) > 0
            
            cell.configure(with: model.date, day: model.dateString, isTodo: isTodo, isDDay: isDday, isSelected: false)
        }
    }
}
