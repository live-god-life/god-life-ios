//
//  MindsetsCell.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/23.
//

import UIKit
import Combine
import CombineCocoa

protocol MindsetsCellDelegate: AnyObject {
    func selectDetail(id: Int)
}

final class MindsetsCell: UICollectionViewCell {
    enum CellType {
        case list
        case title
    }
    
    // MARK: - Properties
    weak var delegate: MindsetsCellDelegate?
    var bag = Set<AnyCancellable>()
    private var list: MindSetsModel?
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
        bind()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Func
    private func makeUI() {
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
    
    private func bind() {
        headerView
            .detailButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let id = self?.list?.goalId else { return }
                
                self?.delegate?.selectDetail(id: id)
            }
            .store(in: &bag)
    }

    func configure(with list: MindSetsModel, type: CellType = .list) {
        headerView.configure(with: list.title)
        
        self.list = list
        updateDataSnapshot(with: list.mindsets ?? [])
        headerView.detailButton.isHidden = type == .title
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
            let cell: MindsetCell = collectionView.dequeueReusableCell(for: indexPath)
            
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
        guard let list = list?.mindsets,
              indexPath.item < list.count else { return .zero }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: MindsetCell.height(with: list[indexPath.item].content))
    }
}
