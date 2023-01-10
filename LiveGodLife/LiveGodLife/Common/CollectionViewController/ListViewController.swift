//
//  ListViewController.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/14.
//

import Foundation
import UIKit
import SwiftyJSON

class ListViewController<Model:Codable, Cell: CommonCell>:
    UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var model: [Model] = []
    var id:String = ""
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        let collectionView = UICollectionView(frame: .zero,
                                         collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.id = Cell.identifier
        self.collectionView.register(Cell.self, forCellWithReuseIdentifier: self.id)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .white
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
//        self.collectionView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //comment 동일한 셀 반복 횟수
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return model.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//
        
        // Configure the cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.id, for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
       
        cell.model = model[indexPath.row]
        cell.setUpModel()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
       print("User tapped on item \(indexPath.row)")
        
    }
    
}

class CommonCell:UICollectionViewCell {

    var model:Codable?
    
    static var identifier: String {
        return String(describing: self)
    }
    func setUpModel() {
        
    }
    
  
}


