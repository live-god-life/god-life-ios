//
//  GoalsListVC.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/30.
//

import UIKit

final class GoalsListVC: UIViewController {
    var baseNavigationController: UINavigationController?
    static var reMindUrl: String = ""
    var model: [GoalModel] = []
    
    var snapshot: GoalsSnapshot!
    var dataSource: GoalsDataSource!
    private lazy var goalsCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        GoalsListCell.register($0)
        $0.register(GoalsListHeadersView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: GoalsListHeadersView.id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(goalsCollectionView)
        
        goalsCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(116)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 16.0
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = .zero
        return flowLayout
    }
}

// MARK: UICollectionViewDataSource
extension GoalsListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GoalsListHeadersView", for: indexPath)
            if let headerView = headerView as? GoalsListHeadersView {
//                headerView.configure(with: "\(self.listView.model.count) List")
            }
            return headerView
        default:
            assert(false, "")
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 40)
    }
}

extension GoalsListVC {
    typealias GoalsSnapshot = NSDiffableDataSourceSnapshot<GoalsListVC.Section, GoalModel>
    typealias GoalsDataSource = UICollectionViewDiffableDataSource<GoalsListVC.Section, GoalModel>
    
    enum Section {
        case goal
    }
    
    private func configureDataSource() {
        dataSource = GoalsDataSource(collectionView: goalsCollectionView) { [weak self] collectionView, indexPath, goal in
            guard let self else { return UICollectionViewCell() }
            
            let cell: GoalsListCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            
            cell.configure(with: goal)
            
            return cell
        }
    }
    
    private func updateDataSnapshot(with goals: [GoalModel]) {
        snapshot = GoalsSnapshot()
        snapshot.appendSections([.goal])
        snapshot.appendItems(goals)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout(with goals: [GoalModel]) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(146.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.interItemSpacing = .fixed(16.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 26.0, leading: .zero, bottom: 128.0, trailing: .zero)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
