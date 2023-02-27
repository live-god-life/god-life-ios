//
//  TasksCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/03/04.
//

import Then
import SnapKit
import UIKit
//MARK: TaskCell
final class TasksCell: UITableViewCell {
    //MARK: - Properties
    private var schedules = [[TodoScheduleViewModel]]() {
        didSet {
            taskCollectionView.reloadData()
        }
    }
    private lazy var taskCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
//        $0.delegate = self
        $0.dataSource = self
        $0.isPagingEnabled = true
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.collectionViewLayout = self.createLayout()
        TaskCell.register($0)
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.backgroundColor = .black
        
        contentView.addSubview(taskCollectionView)
        
        taskCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with schedules: [[TodoScheduleViewModel]]) {
        self.schedules = schedules
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let height = UIScreen.main.bounds.height - 54.0
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(350)))
        item.contentInsets = .zero
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(350)), subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 24.0, leading: .zero, bottom: 24.0, trailing: .zero)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .zero
        return UICollectionViewCompositionalLayout(section: section)
   }
}

extension TasksCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TaskCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.contentView.backgroundColor = indexPath.row == 0 ? .red : .blue
        cell.configure(with: schedules[indexPath.row])
        return cell
    }
}
