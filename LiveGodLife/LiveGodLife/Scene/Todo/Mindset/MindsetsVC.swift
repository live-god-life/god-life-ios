//
//  MindsetsVC.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/04.
//

import UIKit

final class MindsetsVC: UIViewController {
    //MARK: - Properties
    private var model = [MindSetsModel]()
    private let viewModel = TodoListViewModel()
    private var snapshot: MindsetsListSnapshot!
    private var dataSource: MindsetsListDataSource!
    private lazy var mindsetsCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        MindsetsCell.register($0)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel
            .input
            .requestMindsets
            .send(nil)
    }
    
    // MARK: - Functions...
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(mindsetsCollectionView)
        
        mindsetsCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(96)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
        }
        
        configureDataSource()
    }
    
    private func bind() {
        viewModel
            .output
            .requestMindsets
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                self.model = $0
                self.updateDataSnapshot(with: $0)
            }
            .store(in: &viewModel.bag)
    }
}

extension MindsetsVC {
    typealias MindsetsListSnapshot = NSDiffableDataSourceSnapshot<TodoListViewModel.Section, MindSetsModel>
    typealias MindsetsListDataSource = UICollectionViewDiffableDataSource<TodoListViewModel.Section, MindSetsModel>
    
    private func configureDataSource() {
        dataSource = MindsetsListDataSource(collectionView: mindsetsCollectionView) { collectionView, indexPath, mindsets in
            let cell: MindsetsCell = collectionView.dequeueReusableCell(for: indexPath)
            
            cell.delegate = self
            cell.configure(with: mindsets)
        
            return cell
        }
    }
    
    private func updateDataSnapshot(with list: [MindSetsModel]) {
        snapshot = MindsetsListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(list)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MindsetsVC: UICollectionViewDelegateFlowLayout {
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 24,
                                               left: .zero,
                                               bottom: 88,
                                               right: .zero)
        flowLayout.minimumLineSpacing = 32.0
        flowLayout.minimumInteritemSpacing = 32.0
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: MindsetsCell.height(with: model[indexPath.item]))
    }
}

extension MindsetsVC: MindsetsCellDelegate {
    func selectDetail(id: Int) {
        navigationController?.pushViewController(DetailGoalVC(id: id), animated: true)
    }
}
