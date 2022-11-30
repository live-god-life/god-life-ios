//
//  MindsetListViewController.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/23.
//

import Foundation
import UIKit

class MindsetListViewController: UIViewController {
    var baseNavigationController: UINavigationController?
    static var reMindUrl:String = ""
    var model:[MindSetModel] = []
    
    //let tableView:UITableView = UITableView()
    
    var listView: ListViewController<MindSetModel,MindsetListCell> = {
        let node = ListViewController<MindSetModel,MindsetListCell>()
        return node
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.listView.view)
        self.listView.view.snp.makeConstraints {
            $0.top.equalTo(self.view).offset(140)
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
        self.listView.collectionView.register(MindsetListHeadersView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MindsetListHeadersView")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.removeAll()
        model.append(.init(goalId: 1, title: "이직하기", mindsets:
                            [
                                .init(mindsetId: 0, content: "사는건 레벨업이 아닌 스펙트럼을 넓히는거란 얘길 들었다. 어떤 말보다 용기가 된다.")
        
                            ]
                          )
        )
        model.append(.init(goalId: 2, title: "1년안에 5000만원 모으기", mindsets:
                            [
                                .init(mindsetId: 1, content: "충분한 현금을 보유해라"),
                                .init(mindsetId: 2, content: "잠자는 동안에도 돈이 들어오는 방법을 찾아내지 못한다면 당신은 죽을 때까지 일을 해야만 할 것이다."),
        
                            ]
                          )
        )
        self.listView.model = model
        self.listView.collectionView.reloadData()
    }

}
extension MindsetListViewController: UICollectionViewDelegate {
    
}
extension MindsetListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemHeightSize = 120.0
        return CGSize(width: self.view.frame.width , height: itemHeightSize)
    }

}


extension MindsetListViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //comment 동일한 셀 반복 횟수
        return self.listView.model.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("section:\(self.listView.model[section].mindsets.count)")
        return self.listView.model[section].mindsets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MindsetListCell.identifier, for: indexPath) as? MindsetListCell else {
            return UICollectionViewCell()
        }
        cell.model = self.listView.model[indexPath.row].mindsets
        cell.dataModel = self.listView.model[indexPath.section].mindsets[indexPath.row]
        cell.setUpModel()
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MindsetListHeadersView", for: indexPath)
            if let headerView = headerView as? MindsetListHeadersView {
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
extension MindsetListViewController: MindsetListHeadersViewDelegate {
    func MindsetListHeaderView(_ view: MindsetListHeadersView, go: Bool) {
        // 상세화면 처리하기
    }
}
                
protocol MindsetListHeadersViewDelegate: AnyObject {
    func MindsetListHeaderView(_ view: MindsetListHeadersView, go: Bool)
}


class MindsetListHeadersView: UICollectionReusableView {
    
    /// 버튼 액션 델리게이트
    weak var delegate: MindsetListHeadersViewDelegate? = nil
    var titleLabel = UILabel()
    lazy var detailButton: UIButton = {
        let button = UIButton()
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
