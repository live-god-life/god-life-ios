//
//  CalendarListCell.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/15.
//

import Foundation
import UIKit

class CalendarListCell: CommonCell {
    // MARK: - Variable
    var dataModel:MainGoals? {
        didSet {
            update()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = font
        return label
    }()

    var itemsView: ListViewController<SubGoals,CalendarCell> = {
        let view = ListViewController<SubGoals,CalendarCell>()
        return view
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Func
    override func setUpModel() {
        super.setUpModel()
        dataModel = super.model as? MainGoals ?? MainGoals(title: "", goalId: 1, rawValue: "", todoSchedules: [])
    }
    
    func addViews(){
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(10)
//            $0.height.equalTo(30)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .green
        self.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(1)
        }
        self.addSubview(self.itemsView.view)
        self.itemsView.view.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 5.0
        self.itemsView.collectionView.collectionViewLayout = layout
        self.itemsView.collectionView.delegate = self
        self.itemsView.collectionView.isScrollEnabled = false
    }
    
    func update() {
        itemsView.model = dataModel?.todoSchedules ?? []
        titleLabel.text = "• \(dataModel?.title ?? "")"
        itemsView.collectionView.reloadData()
    }
}
// MARK: - Delegate
extension CalendarListCell: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //comment 동일한 셀 반복 횟수
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.itemsView.model.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as? CalendarCell else {
            return UICollectionViewCell()
        }
        cell.model = self.itemsView.model[indexPath.row]
        cell.setUpModel()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SideMenuHeaderView", for: indexPath)
//            if let headerView = headerView as? SideMenuHeaderView {
//                headerView.delegate = self
//                headerView.updateView(isRegular: LoginMbrInfo.shared.member == .Regular)
//            }
//            return headerView
//        default:
//            assert(false, "")
//        }
        return UICollectionReusableView()
    }
}

extension CalendarListCell:UICollectionViewDelegate {
    
//    private func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // print("menu item: \(dataModel?.menuItem[indexPath.row].action)")
//        if let model = dataModel {
//            if let menuType = MainMenu.init(rawValue: model.rawValue) {
//                let actionType = model.menuItem[indexPath.row].action
//                SideMenuManager.default.rightMenuNavigationController?.dismiss(animated: true) {
//                    switch menuType {
//                    case .myInfo:
//                        MyInfo.init(rawValue: actionType)?.goMenu()
//                    case .reservation:
//                        Reservation.init(rawValue: actionType)?.goMenu()
//                    case .membershipAndEvent:
//                        MembershipAndEvent.init(rawValue: actionType)?.goMenu()
//                    case .history:
//                        History.init(rawValue: actionType)?.goMenu()
//                    case .activityHistory:
//                        ActivityHistory.init(rawValue: actionType)?.goMenu()
//                    case .customerSupport:
//                        CustomerSupport.init(rawValue: actionType)?.goMenu()
//                    }
//                }
//            }
//        }
//    }

}
extension CalendarListCell:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: collectionView.frame.width * 0.45 , height: 30)
        }
        
        let numberOfCells: CGFloat = 2.0
        let itemSize = (collectionView.frame.size.width - (flowLayout.minimumInteritemSpacing * (numberOfCells-1))) / numberOfCells
        return CGSize(width: itemSize, height: 30)
    }
}
