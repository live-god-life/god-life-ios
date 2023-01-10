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
    var selectedIndexPaths = Set<Int>()
    let navigationBarView = CommonNavigationView().then {
        $0.titleLabel.text = "목표상세"
    }
    lazy var detailCollectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 16, left: .zero,
                                       bottom: 44, right: .zero)
        GoalCell.register($0)
        MindsetsCell.register($0)
        DetailTodosCell.register($0)
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
        
        view.addSubview(navigationBarView)
        view.addSubview(detailCollectionView)
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(54)
        }
        detailCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
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
        
        navigationBarView
            .leftBarButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &bag)
    }
    

}

extension DetailGoalVC: UICollectionViewDataSource {
    enum CellType: Int, CaseIterable {
        case title = 0
        case line
        case mindset
        case todo
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let model = viewModel.deatilModel else { return .zero }
        
        return 3 + (model.todos?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = viewModel.deatilModel else { return .zero }
        
        let cellType = CellType(rawValue: section) ?? .todo
        
        switch cellType {
        case .todo:
            let index = section - 3
            if selectedIndexPaths.contains(index) {
                let cellCount = model.todos?[index].childTodos?.count ?? 0
                return cellCount + 1
            }
            return 1
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = viewModel.deatilModel else { return UICollectionViewCell() }
        
        let cellType = CellType(rawValue: indexPath.section) ?? .todo
        
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
        case .todo:
            let cell: DetailTodosCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            let index = indexPath.section - 3
            
            if indexPath.item == 0 {
                let isChild = !(model.todos?[index].childTodos?.isEmpty ?? true)
                var radius: [DetailTodosCell.RadiusType] = [.top]
                var infoImage: UIImage?
                infoImage = !isChild ? UIImage(named: "todoDetail") : selectedIndexPaths.contains(index) ? UIImage(named: "goalTop") : UIImage(named: "goalBottom")
                if !isChild || !selectedIndexPaths.contains(index) { radius.append(.bottom) }
                
                cell.configure(with: model.todos?[index],
                               type: .folder,
                               radius: radius,
                               infoImage: infoImage)
            } else {
                let lastIndex = (model.todos?[index].childTodos?.count ?? .zero)
                let radius: [DetailTodosCell.RadiusType] = indexPath.item == lastIndex ? [.bottom] : [.center]
                
                cell.configure(with: model.todos?[index].childTodos?[indexPath.item - 1],
                               type: .task,
                               radius: radius,
                               infoImage: UIImage(named: "todoDetail"))
            }
            
            return cell
        }
    }
}

extension DetailGoalVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellType = CellType(rawValue: indexPath.section) ?? .todo
        
        guard let model = viewModel.deatilModel, cellType == .todo else { return }
        
        let index = indexPath.section - 3
        let todo = indexPath.item == 0 ? model.todos?[index] : model.todos?[index].childTodos?[indexPath.item - 1]
        let isFolder = todo?.type == "folder"
        
        if isFolder {
            if selectedIndexPaths.contains(index) {
                selectedIndexPaths.remove(index)
            } else {
                selectedIndexPaths.insert(index)
            }
            detailCollectionView.reloadSections(IndexSet(indexPath.section...indexPath.section))
        } else {
            let id = todo?.todoId
            guard let id, let vc = TodoDetailViewController.instance() else { return }
            vc.configure(id: id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DetailGoalVC: UICollectionViewDelegateFlowLayout {
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let model = viewModel.deatilModel else { return .zero }
        
        let cellType = CellType(rawValue: indexPath.section) ?? .todo
        let width = UIScreen.main.bounds.width
        
        switch cellType {
        case .title:
            return CGSize(width: width, height: 146.0)
        case .line:
            return CGSize(width: width, height: 16.0)
        case .mindset:
            return CGSize(width: width, height: MindsetsCell.height(with: MindSetsModel(goalId: model.goalId,
                                                                                        title: model.title,
                                                                                        mindsets: model.mindsets)))
        case .todo:
            return CGSize(width: width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let _ = viewModel.deatilModel else { return .zero }
        
        let cellType = CellType(rawValue: section) ?? .todo
        let width = UIScreen.main.bounds.width
        
        switch cellType {
        case .line:
            return CGSize(width: width, height: 32.0)
        case .mindset:
            return CGSize(width: width, height: 56.0)
        default:
            return CGSize(width: width, height: 16)
        }
    }
}
