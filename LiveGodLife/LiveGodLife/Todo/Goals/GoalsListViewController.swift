//
//  GoalsListViewController.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/30.
//

import Foundation
import UIKit

class GoalsListViewController: UIViewController {
    var baseNavigationController: UINavigationController?
    static var reMindUrl:String = ""
    var model:[GoalsModel] = []
    
    var listView: ListViewController<GoalsModel,MindsetListCell> = {
        let node = ListViewController<GoalsModel,MindsetListCell>()
        return node
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.listView.view)
        self.listView.view.snp.makeConstraints {
            $0.top.equalTo(self.view).offset(150)
            $0.left.equalTo(self.view)
            $0.right.equalTo(self.view)
            $0.bottom.equalTo(self.view).offset(-40)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 5.0
        self.listView.collectionView.collectionViewLayout = layout
        self.listView.collectionView.backgroundColor = .black
        
        self.listView.collectionView.delegate = self
        self.listView.collectionView.dataSource = self
//        self.listView.collectionView.register(MindsetListHeadersView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MindsetListHeadersView")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.removeAll()
        
        self.listView.model = model
        self.listView.collectionView.reloadData()
    }

}
extension GoalsListViewController: UICollectionViewDelegate {
    
}
extension GoalsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemHeightSize = 120.0
        return CGSize(width: self.view.frame.width , height: itemHeightSize)
    }

}


extension GoalsListViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //comment 동일한 셀 반복 횟수
        return self.listView.model.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        print("section:\(self.listView.model[section].mindsets.count)")
//        return self.listView.model[section].mindsets.count
        return self.listView.model.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MindsetListCell.identifier, for: indexPath) as? MindsetListCell else {
//            return UICollectionViewCell()
//        }
//        cell.model = self.listView.model[indexPath.row].mindsets
//        cell.dataModel = self.listView.model[indexPath.section].mindsets[indexPath.row]
//        cell.setUpModel()
       
//        return cell
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 30)
    }
}


