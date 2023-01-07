//
//  DetailGoalVC.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/26.
//

import Then
import SnapKit
import UIKit
import Combine

//MARK: 목표상세
final class DetailGoalVC: UIViewController {
    //MARK: - Properties
    private let id: Int
    var bag = Set<AnyCancellable>()
    let viewModel = DetailViewModel()
    lazy var detailCollectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        GoalCell.register($0)
        MindsetsCell.register($0)
        DefaultCollectionViewCell.register($0)
    }
    
    //MARK: - Life Cycle
    init(id: Int) {
        self.id = id
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel
            .input
            .requestDetailGoal
            .send(id)
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(detailCollectionView)
        
        detailCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        viewModel
            .output
            .requestDetailGoal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.detailCollectionView.reloadData()
            }
            .store(in: &bag)
    }
    

}

extension DetailGoalVC: UICollectionViewDataSource {
    enum CellType: Int, CaseIterable {
        case title = 0
        case line
        case mindset
//        case todo
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let _ = viewModel.deatilModel else { return .zero }
        
        return CellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellType = CellType(rawValue: indexPath.item),
              let model = viewModel.deatilModel else { return UICollectionViewCell() }
        
        switch cellType {
        case .title:
            let cell: GoalCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configure(with: viewModel.deatilModel, type: .title)
            return cell
        case .line:
            let cell: DefaultCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.contentView.backgroundColor = .gray5
            return cell
        case .mindset:
            let cell: MindsetsCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configure(with: MindSetsModel(goalId: model.goalId,
                                               title: "마인드셋",
                                               mindsets: model.mindsets), type: .title)
            return cell
//        case .todo:
//            return UICollectionViewCell()
        }
    }
}

extension DetailGoalVC: UICollectionViewDelegate {
    
}

extension DetailGoalVC: UICollectionViewDelegateFlowLayout {
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 28,
                                               left: .zero,
                                               bottom: 44,
                                               right: .zero)
        flowLayout.minimumLineSpacing = 32.0
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellType = CellType(rawValue: indexPath.item),
              let model = viewModel.deatilModel else { return .zero }
        
        let width = UIScreen.main.bounds.width
        
        switch cellType {
        case .title:
            return CGSize(width: width, height: 138.0)
        case .line:
            return CGSize(width: width, height: 16.0)
        case .mindset:
            return CGSize(width: width, height: MindsetsCell.height(with: MindSetsModel(goalId: model.goalId,
                                                                                        title: model.title,
                                                                                        mindsets: model.mindsets)))
        }
    }
}
