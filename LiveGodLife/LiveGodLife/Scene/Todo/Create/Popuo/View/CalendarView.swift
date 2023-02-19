//
//  CalendarView.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/24.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

protocol CalendarViewDelegate: AnyObject {
    func select(startDate: Date?, endDate: Date?)
    func select(title: Date?)
}

//MARK: CalendarView
final class CalendarView: UIView {
    private var bag = Set<AnyCancellable>()
    weak var delegate: CalendarViewDelegate?
    
    enum Metric {
        static let width = UIScreen.main.bounds.width - 47
        static let defaultPositionX = width * 48
        static let height: CGFloat = 280.0
    }
    
    enum ScrollDirection {
        case prev
        case none
        case next
    }
    
    //MARK: - Properties
    var isEnd = true
    var isBegin = true
    var startDate: Date?
    var endDate: Date?
    var lastOffset = Metric.defaultPositionX
    var scrollDirection: ScrollDirection = .none
    var targetDate: Date? {
        didSet {
            titleLabel.text = dateFormatter.string(from: targetDate ?? Date())
            
            guard isEnd || isBegin else { return }
            guard let targetDate else { return }
            
            var components = DateComponents()
            components.day = 1
            let month = calendar.component(.month, from: targetDate)
            let year = calendar.component(.year, from: targetDate)
            
            self.models = (-48 ... 48).map {
                var y = year + ($0 / 12)
                var m = month + ($0 % 12)
                
                if m < 1 {
                    y -= 1
                    m += 12
                } else if m > 12 {
                    y += 1
                    m -= 12
                }
                
                components.year = y
                components.month = m < 1 ? 12 - m : m > 12 ? m - 12 : m
                return calculation(for: calendar.date(from: components) ?? Date())
            }
        }
    }
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy.MM."
    }
    var models = [[CalendarViewModel]]() {
        didSet {
            guard isEnd || isBegin else { return }
            collectionView.reloadData()
        }
    }
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .semiBold(with: 20)
    }
    let titleImageView = UIImageView().then {
        $0.image = UIImage(named: "calendar-down")
    }
    private let titleButton = UIButton()
    private let prevButton = UIButton().then {
        $0.setImage(UIImage(named: "calendar-left"), for: .normal)
        $0.setImage(UIImage(named: "calendar-left"), for: .highlighted)
    }
    private let nextButton = UIButton().then {
        $0.setImage(UIImage(named: "calendar-right"), for: .normal)
        $0.setImage(UIImage(named: "calendar-right"), for: .highlighted)
    }
    private let weeks = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    lazy var collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        CalendarViewCell.register($0)
    }
    private let calendar = Calendar.current
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard isBegin || isEnd else { return }
        
        collectionView.performBatchUpdates { [weak self] in
            self?.collectionView.setContentOffset(CGPoint(x: Metric.defaultPositionX, y: 0),
                                                  animated: false)
        }
        
        self.isBegin = false
        self.isEnd = false
        self.lastOffset = Metric.defaultPositionX
    }
    
    //MARK: - Make UI
    private func makeUI() {
        addSubview(titleLabel)
        addSubview(titleImageView)
        addSubview(titleButton)
        addSubview(prevButton)
        addSubview(nextButton)
        addSubview(stackView)
        addSubview(collectionView)
        
        weeks.forEach {
            let lbl = UILabel()
            lbl.text = $0
            lbl.font = .montserrat(with: 14, weight: .semibold)
            lbl.textColor = UIColor(rgbHexString: "#8D8D93")
            lbl.textAlignment = .center
            stackView.addArrangedSubview(lbl)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview()
            $0.height.equalTo(30)
        }
        titleImageView.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(10)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(16)
        }
        titleButton.snp.makeConstraints {
            $0.top.left.bottom.equalTo(titleLabel)
            $0.right.equalTo(titleImageView.snp.right)
        }
        nextButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(24)
        }
        prevButton.snp.makeConstraints {
            $0.right.equalTo(nextButton.snp.left).offset(-8)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(24)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
            $0.height.equalTo(20)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(4)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
            $0.height.equalTo(Metric.height)
        }
    }
    
    private func bind() {
        titleButton
            .tapPublisher
            .sink { [weak self] _ in
                self?.delegate?.select(title: self?.targetDate)
            }
            .store(in: &bag)
        
        prevButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.lastOffset -= Metric.width
                self.isBegin = self.lastOffset == .zero
                self.scrollDirection = .prev
                self.collectionView.setContentOffset(CGPoint(x: self.lastOffset, y: .zero),
                                                      animated: true)
                self.moveMonth()
            }
            .store(in: &bag)
        
        nextButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                self.lastOffset += Metric.width
                self.isEnd = self.lastOffset == (Metric.width * CGFloat(self.models.count - 1))
                self.scrollDirection = .next
                self.collectionView.setContentOffset(CGPoint(x: self.lastOffset, y: .zero),
                                                      animated: true)
                self.moveMonth()
            }
            .store(in: &bag)
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: Metric.width, height: Metric.height)
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        layout.sectionInset = .zero
        return layout
    }
    
    func configure(with date: Date, startDate: Date?, endDate: Date?) {
        self.startDate = startDate
        self.endDate = endDate
        self.targetDate = date
    }
    
    private func calculation(for date: Date) -> [CalendarViewModel] {
        var components = DateComponents()
        components.year = calendar.component(.year, from: date)
        components.month = calendar.component(.month, from: date)
        components.day = 1
        
        let firstDayOfMonth = calendar.date(from: components) ?? Date()
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let daysCountInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)?.count ?? 0
        let weekdayAdding = 2 - firstWeekday
        
        return (weekdayAdding...daysCountInMonth).map {
            components.day = $0
            let date = $0 < 1 ? nil : calendar.date(from: components)
            let day = $0 < 1 ? "" : "\($0)"
            return CalendarViewModel(date: date, dateString: day)
        }
    }
    
    private func moveMonth() {
        guard let targetDate else { return }
        
        var components = DateComponents()
        components.day = 1
        
        let month = calendar.component(.month, from: targetDate)
        let year = calendar.component(.year, from: targetDate)
        
        switch scrollDirection {
        case .prev:
            components.month = month - 1 < 1 ? 12 : month - 1
            components.year = month - 1 < 1 ? year - 1 : year
        case .next:
            components.month = month + 1 > 12 ? 1 : month + 1
            components.year = month + 1 > 12 ? year + 1 : year
        case .none:
            return
        }
        
        LogUtil.d(calendar.date(from: components) ?? Date())
        self.targetDate = calendar.date(from: components) ?? Date()
    }
}

extension CalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CalendarViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.delegate = self
        cell.configure(with: models[indexPath.item], startDate: startDate, endDate: endDate)
        
        return cell
    }
}

extension CalendarView: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let endOffset: CGFloat = Metric.width * CGFloat(models.count - 1)
        
        if lastOffset == targetContentOffset.pointee.x {
            scrollDirection = .none
        } else if lastOffset < targetContentOffset.pointee.x {
            scrollDirection = .next
        } else {
            scrollDirection = .prev
        }
        
        self.isBegin = targetContentOffset.pointee.x == .zero
        self.isEnd = targetContentOffset.pointee.x == endOffset
        
        lastOffset = targetContentOffset.pointee.x
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        moveMonth()
    }
}

extension CalendarView: CalendarViewCellDelegate {
    func select(_ cell: CalendarViewCell, dayCell: CalendarViewDayCell) {
        guard let date = dayCell.date else { return }
        
        if startDate == nil {
            self.startDate = date
        } else if endDate == nil {
            if startDate! >= date {
                self.endDate = self.startDate
                self.startDate = date
            } else {
                self.endDate = date
            }
        } else {
            self.startDate = date
            self.endDate = nil
        }
        
        delegate?.select(startDate: startDate, endDate: endDate)
        
        collectionView.reloadData()
    }
}
