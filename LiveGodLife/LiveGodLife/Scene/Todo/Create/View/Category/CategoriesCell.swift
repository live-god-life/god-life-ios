//
//  CategoriesCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/02.
//

import Then
import SnapKit
import UIKit

protocol CategoriesCellDelegate: AnyObject {
    func selectedCategory(code: String)
}

//MARK: CategoriesCell
final class CategoriesCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: CategoriesCellDelegate?
    private var models = CategoryModel.models()
    private var snapshot: CategoriesSnapShot!
    private var dataSource: CategoriesDataSource!
    private var selectedCategory = 0
    private lazy var categoryCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 40.0, left: 16.0, bottom: 32.0, right: 16.0)
        CategoryCell.register($0)
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.backgroundColor = .black
        
        contentView.addSubview(categoryCollectionView)
        
        categoryCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        configureDataSource()
        
        updateDataSnapshot(with: models)
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.minimumInteritemSpacing = 8.0
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        return flowLayout
    }
    
    func configure(selected code: String) {
        let name = CategoryCode.name(category: code)
        if let idx = models.firstIndex(where: { $0.name == name }) {
            models[idx].isSelected = true
            updateDataSnapshot(with: models)
        }
    }
}

extension CategoriesCell {
    typealias CategoriesSnapShot = NSDiffableDataSourceSnapshot<TodoListViewModel.Section, CategoryModel>
    typealias CategoriesDataSource = UICollectionViewDiffableDataSource<TodoListViewModel.Section, CategoryModel>
    
    private func configureDataSource() {
        dataSource = CategoriesDataSource(collectionView: categoryCollectionView) { collectionView, indexPath, category in
            
            let cell: CategoryCell = collectionView.dequeueReusableCell(for: indexPath)
            
            cell.configure(category: category.name,
                           isSelected: category.isSelected)
            
            return cell
        }
    }
    
    private func updateDataSnapshot(with categories: [CategoryModel]) {
        snapshot = CategoriesSnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(categories)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension CategoriesCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        models[selectedCategory].isSelected = false
        selectedCategory = indexPath.item
        models[selectedCategory].isSelected = true
        
        updateDataSnapshot(with: models)
        
        guard let category = CategoryCode(rawValue: models[selectedCategory].name) else { return }
        delegate?.selectedCategory(code: category.code)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CategoryCell.width(text: models[indexPath.item].name)
        return CGSize(width: width, height: 36.0)
    }
}
