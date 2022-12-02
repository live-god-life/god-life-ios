//
//  CalendarListViewController.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/15.
//

import Foundation
import UIKit

class CalendarListViewController: UIViewController {
    var baseNavigationController: UINavigationController?
    static var reMindUrl:String = ""
    var model:[MainCalendarModel] = []

    var listView: ListViewController<MainCalendarModel,CalendarListCell> = {
        let node = ListViewController<MainCalendarModel,CalendarListCell>()
        return node
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        let todayLabel = UILabel()
        let addButton = UIButton()
        
        todayLabel.text = Date.today
        todayLabel.textColor = .white
        
        self.view.addSubview(todayLabel)
        self.view.addSubview(addButton)
        self.view.addSubview(self.listView.view)
        todayLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(90)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            make.height.equalTo(30)
        }
        self.listView.view.snp.makeConstraints {
            $0.top.equalTo(todayLabel.snp.bottom).offset(16)
            $0.left.equalTo(self.view)
            $0.right.equalTo(self.view)
            $0.bottom.equalTo(addButton.snp.top).offset(-40)
        }
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(30)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)

        }
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 5.0
        self.listView.collectionView.collectionViewLayout = layout
        self.listView.collectionView.backgroundColor = .black

        addButton.backgroundColor = .blue
        self.listView.collectionView.delegate = self
        self.listView.collectionView.dataSource = self
        self.listView.collectionView.register( CalendarListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarListHeaderView")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.removeAll()
        model.append(.init(title: "스케치", goalId: 1, rawValue: "", todoSchedules:
                            [
                                SubCalendarModel(
                                    title: "컨셉잡기",
                                    completionStatus: false,
                                    taskType: "Todo",
                                    repetitionType: "WEEK",
                                    repetitionParams: [
                                        "월",
                                        "목",
                                        "토"
                                    ],
                                    totalTodoTaskScheduleCount: 39,
                                    completedTodoTaskScheduleCount: 0,
                                    todoDay: -48),
                                SubCalendarModel(
                                    title: "컨셉잡기1",
                                    completionStatus: false,
                                    taskType: "Todo",
                                    repetitionType: "WEEK",
                                    repetitionParams: [
                                        "월",
                                        "목",
                                        "토"
                                    ],
                                    totalTodoTaskScheduleCount: 39,
                                    completedTodoTaskScheduleCount: 0,
                                    todoDay: -48),
                            ]
                          )
        )
        model.append(.init(title: "이직하기", goalId: 1, rawValue: "", todoSchedules:
                            [
                                SubCalendarModel(
                                    title: "테스트",
                                    completionStatus: false,
                                    taskType: "D-999",
                                    repetitionType: "DAY",
                                    repetitionParams: nil,
                                    totalTodoTaskScheduleCount: 91,
                                    completedTodoTaskScheduleCount: 0,
                                    todoDay: -48)
                            ]
                          )
        )

        self.listView.model = model
        self.listView.collectionView.reloadData()

    }

}

extension CalendarListViewController: UICollectionViewDelegate {
    
}
extension CalendarListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemHeightSize = 75.0
        return CGSize(width: self.view.frame.width , height: itemHeightSize)
    }

}


extension CalendarListViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //comment 동일한 셀 반복 횟수
        return self.listView.model.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("section:\(self.listView.model[section].todoSchedules.count)")
        return self.listView.model[section].todoSchedules.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarListCell.identifier, for: indexPath) as? CalendarListCell else {
            return UICollectionViewCell()
        }
//        cell.model = self.listView.model[indexPath.row].todoSchedules
        cell.dataModel = self.listView.model[indexPath.section].todoSchedules[indexPath.row]
        cell.setUpModel()
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CalendarListHeaderView", for: indexPath)
            if let headerView = headerView as? CalendarListHeaderView {
                headerView.titleLabel.text = model[indexPath.section].title
                headerView.delegate = self
            }
            return headerView
        default:
            assert(false, "")
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 30)
    }
}
extension CalendarListViewController: CalendarListHeaderViewDelegate {
    func calendarListHeaderView(_ view: CalendarListHeaderView, go: Bool) {
        // 상세화면 처리하기
    }}
protocol CalendarListHeaderViewDelegate: AnyObject {
    func calendarListHeaderView(_ view: CalendarListHeaderView, go: Bool)
}
class CalendarListHeaderView: UICollectionReusableView {
    
    /// 버튼 액션 델리게이트
    weak var delegate: CalendarListHeaderViewDelegate? = nil
    var titleLabel = UILabel()
    lazy var detailButton: UIButton = {
        let button = UIButton()
//        button.setImage(#imageLiteral(resourceName: "icon-close-20.pdf"), for: .normal)
//        button.addTarget(self, action: #selector(self.closeAction(_:)), for: .touchUpInside)
        return button
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    
    func setUpView() {
        self.backgroundColor = .black
        self.titleLabel.textColor = .white
        
        self.addSubview(titleLabel)
        self.addSubview(detailButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(24)
        }
        detailButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalToSuperview()
            make.height.equalTo(24)
        }
    }
    // MARK: - Button Action
    @objc func closeAction(_ sender: UIButton) {
//        delegate?.sideMenuHeaderView(self, selectedClose: true)
    }
}
