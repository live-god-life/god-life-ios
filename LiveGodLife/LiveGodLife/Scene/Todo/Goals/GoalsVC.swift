//
//  GoalsVC.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/30.
//

import UIKit

final class GoalsVC: UIViewController {
    private var status: Bool?
    private let viewModel = TodoListViewModel()
    private var snapshot: GoalsSnapshot!
    private var dataSource: GoalsDataSource!
    
    private lazy var popupView = GoalStatusPopupView().then {
        $0.delegate = self
        $0.isHidden = true
    }
    private lazy var goalsCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        GoalCell.register($0)
        $0.register(GoalsHeadersView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
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
            .send(status)
    }
    
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(goalsCollectionView)
        view.addSubview(popupView)
        
        goalsCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(116)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
        }
        popupView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(178)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(98)
            $0.height.equalTo(136)
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
        
        navigationController?.pushViewController(DetailGoalVC(id: goalID), animated: true)
    }
}

extension GoalsVC {
    typealias GoalsSnapshot = NSDiffableDataSourceSnapshot<TodoListViewModel.Section, GoalModel>
    typealias GoalsDataSource = UICollectionViewDiffableDataSource<TodoListViewModel.Section, GoalModel>
    
    private func configureDataSource() {
        dataSource = GoalsDataSource(collectionView: goalsCollectionView) { collectionView, indexPath, goal in
            let cell: GoalCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: goal)
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: GoalsHeadersView.id,
                                                                             for: indexPath) as? GoalsHeadersView
            
            let itemCount = self.dataSource.snapshot().numberOfItems(inSection: .main)
            
            headerView?.delegate = self
            headerView?.configure(title: "\(itemCount) List", status: self.status)
            
            return headerView
        }
    }
    
    private func updateDataSnapshot(with goals: [GoalModel]) {
        snapshot = GoalsSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(goals)
        dataSource.apply(snapshot, animatingDifferences: false)
        goalsCollectionView.reloadData()
    }
}

extension GoalsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 66.0)
    }
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: .zero,
                                               left: .zero,
                                               bottom: 88,
                                               right: .zero)
        flowLayout.minimumLineSpacing = 16.0
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 146.0)
    }
}

extension GoalsVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        popupView.isHidden = true
    }
}

extension GoalsVC: GoalsHeadersViewDelegate {
    func selectStatus() {
        popupView.isHidden.toggle()
    }
}

extension GoalsVC: GoalStatusPopupViewDelegate {
    func selected(status: Bool?) {
        self.status = status
        viewModel.input.requestGoals.send(status)
    }
}
