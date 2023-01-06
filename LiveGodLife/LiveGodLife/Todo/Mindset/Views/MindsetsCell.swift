//
//  MindsetsCell.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/23.
//

import UIKit

final class MindsetsCell: UICollectionViewCell {
    // MARK: - Properties
    private var mindsets = [MindSetModel]()
    private var snapshot: MindsetsSnapshot!
    private var dataSource: MindsetsDataSource!
    private let headerView = MindsetListHeadersView()
    private lazy var mindsetCollectionView = UICollectionView(frame: .zero,
                                                              collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        MindsetCell.register($0)
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Func
    private func makeUI(){
        backgroundColor = .black
        
        contentView.addSubview(headerView)
        contentView.addSubview(mindsetCollectionView)
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(32)
        }
        mindsetCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(14)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        configureDataSource()
    }

    func configure(with list: MindSetsModel) {
        headerView.configure(with: list.title)
        
        mindsets = list.mindsets ?? []
        updateDataSnapshot(with: list.mindsets ?? [])
    }
    
    static func height(with list: MindSetsModel) -> CGFloat {
        guard let mindsets = list.mindsets,
              !mindsets.isEmpty else { return .zero }
        
        var height = 46.0
        height += mindsets.reduce(CGFloat.zero) { result, mindset in
            result + MindsetCell.height(with: mindset.content)
        }
        
        let spacingCount = Double(mindsets.count - 1)
        return height + (spacingCount * 16.0)
    }
}

extension MindsetsCell {
    typealias MindsetsSnapshot = NSDiffableDataSourceSnapshot<TodoListViewModel.Section, MindSetModel>
    typealias MindsetsDataSource = UICollectionViewDiffableDataSource<TodoListViewModel.Section, MindSetModel>
    
    private func configureDataSource() {
        dataSource = MindsetsDataSource(collectionView: mindsetCollectionView) { collectionView, indexPath, mindset in
            let cell: MindsetCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            
            cell.configure(with: mindset)
            
            return cell
        }
    }
    
    private func updateDataSnapshot(with mindsets: [MindSetModel]) {
        snapshot = MindsetsSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(mindsets, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MindsetsCell: UICollectionViewDelegateFlowLayout {
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 16.0
        flowLayout.minimumInteritemSpacing = 16.0
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard indexPath.item < mindsets.count else { return .zero }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: MindsetCell.height(with: mindsets[indexPath.item].content))
    }
}
