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
    func select(date: Date)
    func select(startDate: Date?, endDate: Date?)
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
    var type: CalendarViewCell.CellType
    var isEnd = true
    var isBegin = true
    var startDate: Date?
    var endDate: Date?
    var lastOffset = Metric.defaultPositionX
    var scrollDirection: ScrollDirection = .none
    private let years = (2000 ... 2100).map { $0 }
    private let month = (1 ... 12).map { $0 }
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
        $0.dateFormat = "yyyy. MM"
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
    private let prevButton = UIButton()
    private let prevImageButton = UIButton().then {
        $0.setImage(UIImage(named: "calendar-left"), for: .normal)
        $0.setImage(UIImage(named: "calendar-left"), for: .highlighted)
    }
    private let nextButton = UIButton()
    private let nextImageButton = UIButton().then {
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
    private let pickerContainerView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0.0
    }
    private let pickerView = UIPickerView()
    
    private let calendar = Calendar.current
    
    //MARK: - Initializer
    init(type: CalendarViewCell.CellType) {
        self.type = type
        
        super.init(frame: .zero)
        
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
        addSubview(prevImageButton)
        addSubview(nextImageButton)
        addSubview(prevButton)
        addSubview(nextButton)
        addSubview(stackView)
        addSubview(collectionView)
        addSubview(pickerContainerView)
        pickerContainerView.addSubview(pickerView)
        
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
            $0.left.equalTo(titleLabel.snp.right).offset(8)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(16)
        }
        titleButton.snp.makeConstraints {
            $0.top.left.bottom.equalTo(titleLabel)
            $0.right.equalTo(titleImageView.snp.right)
        }
        nextImageButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(24)
        }
        prevImageButton.snp.makeConstraints {
            $0.right.equalTo(nextImageButton.snp.left).offset(-8)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.size.equalTo(24)
        }
        nextButton.snp.makeConstraints {
            $0.left.equalTo(prevImageButton.snp.right).offset(4)
            $0.centerY.equalTo(nextImageButton)
            $0.width.equalTo(48)
            $0.height.equalTo(52)
        }
        prevButton.snp.makeConstraints {
            $0.right.equalTo(nextButton.snp.left)
            $0.centerY.equalTo(prevImageButton)
            $0.width.equalTo(48)
            $0.height.equalTo(52)
        }
        nextButton.snp.makeConstraints {
            $0.left.equalTo(prevImageButton.snp.right).offset(4)
            $0.centerY.equalTo(nextImageButton)
            $0.width.equalTo(48)
            $0.height.equalTo(52)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
            $0.height.equalTo(20)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(8)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().offset(-7)
            $0.height.equalTo(Metric.height)
        }
        pickerContainerView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(321)
        }
        pickerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(238)
        }
    }
    
    private func bind() {
        titleButton
            .tapPublisher
            .sink { [weak self] _ in
                guard let self, let date = self.targetDate else { return }
                
                let isOpen = self.pickerContainerView.alpha == .zero
                
                let year = self.calendar.component(.year, from: date) - 2000
                let month = self.calendar.component(.month, from: date) - 1
                self.pickerView.selectRow(year, inComponent: 0, animated: false)
                self.pickerView.selectRow(month, inComponent: 1, animated: false)
                
                let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
                let angle: CGFloat = isOpen ? .pi : -.pi * 2
                let tr = CGAffineTransform.identity.rotated(by: angle)
                
                animator.addAnimations {
                    self.pickerContainerView.alpha = isOpen ? 1.0 : .zero
                    self.titleImageView.transform = tr
                }
                
                animator.startAnimation()
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
    
    func configure(with date: Date, startDate: Date? = nil, endDate: Date? = nil) {
        self.startDate = startDate
        self.endDate = endDate
        self.targetDate = date
        
        if type == .todo, self.startDate == nil {
            self.startDate = Date()
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .black
        
        let year = calendar.component(.year, from: targetDate ?? Date()) - 2000
        let month = calendar.component(.month, from: targetDate ?? Date()) - 1
        
        pickerView.selectRow(year, inComponent: 0, animated: false)
        pickerView.selectRow(month, inComponent: 1, animated: false)
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
        cell.configure(type: self.type, with: models[indexPath.item], startDate: startDate, endDate: endDate)
        
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

extension CalendarView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 101 : 12
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let text = component == 0 ? "\(years[row])년" : "\(month[row])월"
        let lbl = UILabel()
        lbl.text = text
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.font = .semiBold(with: 22)
        return lbl
    }
}

extension CalendarView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let date = self.targetDate else { return }
        
        var components = DateComponents()
        
        let year = years[pickerView.selectedRow(inComponent: 0)]
        let month = month[pickerView.selectedRow(inComponent: 1)]
        
        components.year = year
        components.month = month
        components.day = 1
        
        if year != calendar.component(.year, from: date) || month != calendar.component(.month, from: date) {
            self.isEnd = true
            self.targetDate = calendar.date(from: components)
        }
    }
}

extension CalendarView: CalendarViewCellDelegate {
    func select(_ cell: CalendarViewCell, dayCell: CalendarDayCell) {
        guard let date = dayCell.date else { return }
        
        self.startDate = date
        delegate?.select(date: date)
    }
    
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
