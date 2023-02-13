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
}

//MARK: CalendarViewCell
final class CalendarViewCell: UICollectionViewCell {
    //MARK: - Properties
    var startDate: Date?
    var endDate: Date?
    weak var delegate: CalendarViewCellDelegate?
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
        CalendarViewDayCell.register($0)
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
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with model: [CalendarViewModel], startDate: Date?, endDate: Date?) {
        self.days = model
        self.startDate = startDate
        self.endDate = endDate
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
        let cell: CalendarViewDayCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.configure(with: days[indexPath.item], startDate: startDate, endDate: endDate)
        
        return cell
    }
}

extension CalendarViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarViewDayCell else {
            return
        }
        
        delegate?.select(self, dayCell: cell)
    }
}
