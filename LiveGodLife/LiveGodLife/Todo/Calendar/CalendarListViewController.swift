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
    var model:[MainGoals] = []
    
    //let tableView:UITableView = UITableView()
    
    var listView: ListViewController<MainGoals,CalendarListCell> = {
        let node = ListViewController<MainGoals,CalendarListCell>()
        return node
    }()
    
    lazy var contentsView: UIView = {
        let view = UIView()
        let todayLabel = UILabel()
        let addButton = UIButton()
        
        todayLabel.text = Date.today
        
        self.listView.collectionView.delegate = self
        self.listView.collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.listView.collectionView.collectionViewLayout = layout
//        self.listView.collectionView.register( SideMenuHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SideMenuHeaderView")
        model.removeAll()
        model.append(.init(title: "스케치", goalId: 1, rawValue: "", todoSchedules:
                            [
                                SubGoals(
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
                                SubGoals(
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
                                SubGoals(
                                    title: "테스트",
                                    completionStatus: false,
                                    taskType: "Todo",
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
        addButton.backgroundColor = .black
        view.backgroundColor = .green
        
        view.addSubview(todayLabel)
        view.addSubview(self.listView.view)
        view.addSubview(addButton)
        view.backgroundColor = .red
        
        self.listView.view.backgroundColor = .yellow
        todayLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        self.listView.view.snp.makeConstraints { make in
            make.top.equalTo(todayLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(addButton.snp.top).offset(10)
        }
        addButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(30)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.contentsView)
        self.contentsView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view.safeAreaInsets)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        model.removeAll()
////        MainMenu.allCases.forEach {
////            /// 간편세차 및 준회원에 따른 모델 객체 패스 처리 로직 필요
////            model.append(MenuModel(title: $0.title,rawValue: $0.rawValue, menuItem: $0.menuItem))
////        }
//
//        model.append(.init(title: "스케치", goalId: 1, rawValue: "", todoSchedules:
//                            [
//                                SubGoals(
//                                    title: "컨셉잡기",
//                                    completionStatus: false,
//                                    taskType: "Todo",
//                                    repetitionType: "WEEK",
//                                    repetitionParams: [
//                                        "월",
//                                        "목",
//                                        "토"
//                                    ],
//                                    totalTodoTaskScheduleCount: 39,
//                                    completedTodoTaskScheduleCount: 0,
//                                    todoDay: -48)
//                            ]
//                          )
//        )
//        model.append(.init(title: "이직하기", goalId: 1, rawValue: "", todoSchedules:
//                            [
//                                SubGoals(
//                                    title: "컨셉잡기",
//                                    completionStatus: false,
//                                    taskType: "Todo",
//                                    repetitionType: "DAY",
//                                    repetitionParams: nil,
//                                    totalTodoTaskScheduleCount: 91,
//                                    completedTodoTaskScheduleCount: 0,
//                                    todoDay: -48)
//                            ]
//                          )
//        )
//
//        self.listView.model     = model
//        self.listView.collectionView.reloadData()
    }

}

extension CalendarListViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        var itemHeightSize = 150.0
//        if indexPath.row < self.listView.model.count {
//            let mainGoals = self.model[indexPath.row]
//            let row = ceil( Double(mainGoals.todoSchedules.count)/2.0 )
//            itemHeightSize = max( 1, row ) * (30 + 5) + 72
//        }
//        return CGSize(width: collectionView.frame.width * 0.9, height: itemHeightSize)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
////        let headerHeight: CGFloat = LoginMbrInfo.shared.member == .Regular ? SideMenuHeaderView.RegularMemberHeight : SideMenuHeaderView.AssociateMemberHeight
////        return CGSize(width: collectionView.frame.width, height: headerHeight)
//        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
//
//    }
}


extension CalendarListViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //comment 동일한 셀 반복 횟수
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarListCell.identifier, for: indexPath) as? CalendarListCell else {
            return UICollectionViewCell()
        }
        cell.model = self.listView.model[indexPath.row]
        cell.setUpModel()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
////        switch kind {
////        case UICollectionView.elementKindSectionHeader:
////            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SideMenuHeaderView", for: indexPath)
////            if let headerView = headerView as? SideMenuHeaderView {
////                headerView.delegate = self
////                headerView.updateView(isRegular: LoginMbrInfo.shared.member == .Regular)
////            }
////            return headerView
////        default:
////            assert(false, "")
////        }
//        return UICollectionReusableView()
//    }
}
