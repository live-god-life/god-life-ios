//
//  GoalsVC.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/30.
//

import UIKit

final class GoalsVC: UIViewController {
    private let viewModel = TodoListViewModel()
    private var snapshot: GoalsSnapshot!
    private var dataSource: GoalsDataSource!
    
    private lazy var goalsCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: createLayout()).then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        GoalCell.register($0)
        $0.register(GoalsHeadersView.self,
                    forSupplementaryViewOfKind: GoalsHeadersView.id,
                    withReuseIdentifier: GoalsHeadersView.id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        makeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel
            .input
            .requestGoals
            .send(nil)
    }
    
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(goalsCollectionView)
        
        goalsCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(116)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
        }
        
        configureDataSource()
    }
    
    private func bind() {
        viewModel
            .output
            .requestGoals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.updateDataSnapshot(with: $0)
            }
            .store(in: &viewModel.bag)
    }
}

// MARK: UICollectionViewDataSource
extension GoalsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let goalID = dataSource.itemIdentifier(for: indexPath)?.goalId else { return }
        
        present(DetailGoalVC(id: goalID), animated: true)
    }
}

extension GoalsVC {
    typealias GoalsSnapshot = NSDiffableDataSourceSnapshot<TodoListViewModel.Section, GoalModel>
    typealias GoalsDataSource = UICollectionViewDiffableDataSource<TodoListViewModel.Section, GoalModel>
    
    private func configureDataSource() {
        dataSource = GoalsDataSource(collectionView: goalsCollectionView) { collectionView, indexPath, goal in
            let cell: GoalCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configure(with: goal)
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == GoalsHeadersView.id else { return nil }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: GoalsHeadersView.id,
                                                                             for: indexPath) as? GoalsHeadersView
            
            let itemCount = self.dataSource.snapshot().numberOfItems(inSection: .main)
            headerView?.configure(with: "\(itemCount) List")
            
            return headerView
        }
    }
    
    private func updateDataSnapshot(with goals: [GoalModel]) {
        snapshot = GoalsSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(goals)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(66.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: GoalsHeadersView.id,
                                                                 alignment: .top)
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(146.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let height = UIScreen.main.bounds.height - 40 - 116 - view.safeAreaInsets.top
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        group.interItemSpacing = .fixed(16.0)
        group.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: 88.0, trailing: .zero)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 16.0
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
