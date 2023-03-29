//
//  TodoDetailVC.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/04.
//

import UIKit
import SnapKit
import Combine

final class TodoDetailVC: UIViewController {
    //MARK: - Properties
    private var id: Int
    private var bag = Set<AnyCancellable>()
    private var taskType: TaskType
    private let viewModel = TodoListViewModel()
    private var taskInfoViewModel: TaskInfoViewModel? {
        didSet {
            self.taskInfoView.configure(with: taskInfoViewModel)
        }
    }
    private var schedules = [TodoScheduleViewModel]()
    private lazy var navigationView = CommonNavigationView().then {
        $0.titleLabel.text = self.taskType == .todo ? "루틴 상세" : "할 일 상세"
    }
    private lazy var taskInfoView = TaskInfoView(isTodo: self.taskType == .todo)
    private lazy var todoTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.separatorColor = .clear
        $0.backgroundColor = .black
        $0.alwaysBounceHorizontal = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .zero
        TaskTableViewCell.xibRegister($0)
    }
    private lazy var headerView = PageSelectionView().then {
        $0.delegate = self
    }
    
    //MARK: - Life Cycle
    init(type: TaskType, id: Int) {
        self.id = id
        self.taskType = type
        
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
    
    //MARK: - Functions...
    private func makeUI() {
        view.backgroundColor = .black
        
        todoTableView.tableHeaderView = taskInfoView
        view.addSubview(navigationView)
        view.addSubview(todoTableView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
        todoTableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        headerView.configure(with: taskType, isNext: true)
    }
    
    private func bind() {
        viewModel
            .output
            .requestDetailTodo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.taskInfoViewModel = TaskInfoViewModel(data: model)
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestDetailTodos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] models in
                self?.schedules = models
                self?.todoTableView.reloadData()
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestStatus
            .sink { [weak self] _ in
                guard let self else { return }
                self.viewModel.input.requestDetailTodo.send(self.id)
            }
            .store(in: &viewModel.bag)
        
        viewModel.input.requestDetailTodo.send(id)
        viewModel.input.requestDetailTodos.send((id, true))
    }
}

// MARK: - Make UI
extension TodoDetailVC {
    enum TaskType {
        case todo
        case dDay
    }
}

extension TodoDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard schedules.count > indexPath.row else { return UITableViewCell() }
        
        let model = schedules[indexPath.row]
        let cell: TaskTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        cell.configure(model, isAfter: headerView.nextButton.isSelected, isRepeated: taskType == .todo)
        
        return cell
    }
}

extension TodoDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132.0
    }
}

extension TodoDetailVC: PageSelectionViewDelegate {
    func select(isNext: Bool) {
        viewModel.input.requestDetailTodos.send((id, isNext))
    }
}

extension TodoDetailVC: TaskTableViewCellDelegate {
    func selectCompleted(_ cell: TaskTableViewCell, id: Int?, isCompleted: Bool) {
        guard let index = todoTableView.indexPath(for: cell)?.row,
              let todoScheduleId = id else { return }
        
        schedules[index].completionStatus = isCompleted
        viewModel.input.requestStatus.send((todoScheduleId, isCompleted))
    }
}
