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
    private let viewModel = TodoListViewModel()
    private var selectedIndexPaths = Set<Int>()
    
    private let updateView = UIView().then {
        $0.isHidden = true
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.gray3.cgColor
        $0.layer.cornerRadius = 8.0
        $0.backgroundColor = .black
    }
    private let updateButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.setTitle("수정", for: .highlighted)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.white, for: .highlighted)
    }
    private let deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitle("삭제", for: .highlighted)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.white, for: .highlighted)
    }
    private let navigationBarView = CommonNavigationView().then {
        $0.titleLabel.text = "목표상세"
        $0.rightBarButton.isHidden = false
    }
    private lazy var detailCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 24, left: .zero,
                                       bottom: 44, right: .zero)
        GoalCell.register($0)
        MindsetsCell.register($0)
        DetailTodosCell.register($0)
        DefaultCell.register($0)
    }
    
    //MARK: - Initializer
    init(id: Int) {
        self.id = id
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
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
        view.addSubview(updateView)
        updateView.addSubview(updateButton)
        updateView.addSubview(deleteButton)
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
        detailCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        updateView.snp.makeConstraints {
            $0.right.equalTo(navigationBarView.rightBarButton.snp.left)
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.width.equalTo(98)
            $0.height.equalTo(96)
        }
        updateButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
        deleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        navigationBarView
            .rightBarButton
            .tapPublisher
            .sink { [weak self] in
                self?.updateView.isHidden.toggle()
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestDetailGoal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.detailCollectionView.reloadData()
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestDeleteGoal
            .sink { [weak self] isSuccess in
                guard let self else { return }
                guard isSuccess else {
                    let alert = UIAlertController(title: "알림", message: "삭제에 실패했습니다.\n다시 시도해주세요😭", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.bag)
        
        updateButton
            .tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                
                let alert = UIAlertController(title: "목표를 수정하시겠습니까?", message: "수정시 완료 처리한 TODO들이 삭제 됩니다.\n완료 이력을 유지하려면 새로 등록해 주세요.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "수정하기", style: .default) { _ in
                    guard let goal = self.viewModel.deatilModel else { return }
                    
                    let title = goal.title ?? ""
                    let category = goal.category ?? ""
                    let mindsets = goal.mindsets ?? []
                    let todos = goal.todos ?? []
                    var todosModel: [TodosModel] = []
                    
                    for (idx, todo) in todos.enumerated() {
                        var j = -1
                        todosModel.append(TodosModel(title: todo.title ?? "",
                                                     type: todo.type ?? "",
                                                     depth: 1,
                                                     orderNumber: idx,
                                                     startDate: todo.startDate,
                                                     endDate: todo.endDate,
                                                     repetitionType: todo.repetitionType,
                                                     repetitionParams: todo.repetitionParams,
                                                     notification: todo.notification,
                                                     todos: (todo.childTodos ?? []).map {
                            j += 1
                            return ChildTodo(title: $0.title ?? "",
                                             type: $0.type ?? "",
                                             depth: 2,
                                             orderNumber: j,
                                             startDate: $0.startDate ?? "",
                                             endDate: $0.endDate ?? "",
                                             repetitionType: $0.repetitionType ?? "")
                            }))
                    }
                    
                    let model = CreateGoalsModel(title: title,
                                                 categoryCode: category,
                                                 mindsets: mindsets.map { GoalsMindset(content: $0.content ?? "") },
                                                 todos: todosModel)
                    let updateGoals = GoalsCreateVC(editType: .update(self.id), model: model)
                    self.navigationController?.pushViewController(updateGoals, animated: true)
                }
                alert.addAction(okAction)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            }
            .store(in: &viewModel.bag)
        
        deleteButton
            .tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                
                let alert = UIAlertController(title: "알림", message: "목표를 삭제하시겠습니까?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                    self.viewModel.input.requestDeleteGoal.send(self.id)
                }
                alert.addAction(okAction)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            }
            .store(in: &viewModel.bag)
        
        
    }
}

//MARK: - UICollectionViewDataSource
extension DetailGoalVC: UICollectionViewDataSource {
    enum SectionType: Int, CaseIterable {
        case title = 0
        case line
        case mindset
        case todoHeader
        case todo
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let model = viewModel.deatilModel else { return .zero }
        
        return 4 + (model.todos?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = viewModel.deatilModel else { return .zero }
        
        let cellType = SectionType(rawValue: section) ?? .todo
        
        switch cellType {
        case .todo:
            let index = section - 4
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
        
        let cellType = SectionType(rawValue: indexPath.section) ?? .todo
        
        switch cellType {
        case .title:
            let cell: GoalCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: viewModel.deatilModel, type: .title)
            return cell
        case .line:
            let cell: DefaultCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.contentView.backgroundColor = .gray5
            return cell
        case .mindset:
            let cell: MindsetsCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: MindSetsModel(goalId: model.goalId,
                                               title: "마인드셋",
                                               mindsets: model.mindsets), type: .title)
            return cell
        case .todoHeader:
            let cell: DefaultCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: "TODO")
            return cell
        case .todo:
            let cell: DetailTodosCell = collectionView.dequeueReusableCell(for: indexPath)
            let index = indexPath.section - 4
            
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

//MARK: - UICollectionViewDelegate
extension DetailGoalVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellType = SectionType(rawValue: indexPath.section) ?? .todo
        
        guard let model = viewModel.deatilModel, cellType == .todo else { return }
        
        let index = indexPath.section - 4
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
            guard let id else { return }
            
            let todoType = todo?.repetitionType ?? ""
            let todoDetailVC = TodoDetailVC(type: todoType == "NONE" ? .dDay : .todo, id: id)
            navigationController?.pushViewController(todoDetailVC, animated: true)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
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
        
        let cellType = SectionType(rawValue: indexPath.section) ?? .todo
        let width = UIScreen.main.bounds.width
        
        switch cellType {
        case .title:
            return CGSize(width: width, height: 144.0)
        case .line:
            return CGSize(width: width, height: 16.0)
        case .mindset:
            return CGSize(width: width, height: MindsetsCell.height(with: MindSetsModel(goalId: model.goalId,
                                                                                        title: model.title,
                                                                                        mindsets: model.mindsets)))
        case .todoHeader:
            return CGSize(width: width, height: 28.0)
        case .todo:
            return CGSize(width: width, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let _ = viewModel.deatilModel else { return .zero }
        
        let cellType = SectionType(rawValue: section) ?? .todo
        let width = UIScreen.main.bounds.width
        
        switch cellType {
        case .line:
            return CGSize(width: width, height: 32.0)
        case .mindset:
            return CGSize(width: width, height: 40.0)
        case .todoHeader:
            return CGSize(width: width, height: 16.0)
        default:
            return CGSize(width: width, height: 16.0)
        }
    }
}
