//
//  GoalsCreateVC.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/31.
//

import Then
import SnapKit
import UIKit
import Combine
import CombineCocoa

//MARK: GoalsCreateVC
final class GoalsCreateVC: UIViewController {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    private var model: CreateGoalsModel
    private let viewModel = TodoListViewModel()
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "목표추가"
    }
    private lazy var newGoalTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.separatorColor = .clear
        $0.backgroundColor = .black
        $0.keyboardDismissMode = .onDrag
        $0.alwaysBounceHorizontal = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 46.0, left: .zero,
                                       bottom: 148.0, right: .zero)
        NewGoalTitleCell.register($0)
        CategoriesCell.register($0)
        DefaultTableViewCell.register($0)
        MindsetTableViewCell.register($0)
        SetTodoCell.register($0)
        DeleteFolderCell.register($0)
        CreateTodoCell.register($0)
        EmptyTableViewCell.register($0)
    }
    private let completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitle("완료", for: .highlighted)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.black, for: .highlighted)
        $0.titleLabel?.font = .bold(with: 18)
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 28.0
    }
    
    //MARK: - Life Cycle
    init(model: CreateGoalsModel) {
        self.model = model
        
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
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(navigationView)
        view.addSubview(newGoalTableView)
        view.addSubview(completeButton)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(54)
        }
        completeButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-44)
            $0.height.equalTo(56)
        }
        newGoalTableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        navigationView
            .leftBarButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.bag)
    }
    
    private func showPopup(title: String) {
        guard view.viewWithTag(888) == nil else { return }
        
        DispatchQueue.main.async { [weak self] in
            let popup = PopupView()
            popup.tag = 888
            popup.negativeButton.isHidden = true
            popup.configure(title: title,
                            negativeHandler: { },
                            positiveHandler: {
                popup.removeFromSuperview()
            })
            self?.view.addSubview(popup)
            popup.snp.makeConstraints {
                $0.width.equalTo(327)
                $0.height.equalTo(188)
                $0.center.equalToSuperview()
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension GoalsCreateVC: UITableViewDataSource {
    enum SectionType: Int, CaseIterable {
        case title = 0
        case category
        case line
        case mindsetHeader
        case mindset
        case todoHeader
        case todo
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (SectionType.allCases.count - 1) + max(1, model.todos.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = SectionType(rawValue: section) ?? .todo
        
        switch type {
        case .mindset:
            return model.mindsets.isEmpty ? 1 : model.mindsets.count
        case .todo:
            guard !model.todos.isEmpty else { return 1 }
            let index = section - 6
            let todo = model.todos[index]
            let isFolder = todo.type == "FOLDER"
            var folderRowCount = todo.todos.count
            folderRowCount += folderRowCount < 5 ? 2 : 1
            return isFolder ? folderRowCount : 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = SectionType(rawValue: indexPath.section) ?? .todo
        
        switch type {
        case .title:
            let cell: NewGoalTitleCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case .category:
            let cell: CategoriesCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case .line:
            let cell: DefaultTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.contentView.backgroundColor = .gray5
            return cell
        case .mindsetHeader:
            let cell: DefaultTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: "마인드 셋", isAdd: true)
            cell.delegate = self
            return cell
        case .mindset:
            if model.mindsets.isEmpty {
                let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.configure(text: "마인드셋을 추가해 보세요.")
                return cell
            } else {
                let cell: MindsetTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.delegate = self
                cell.configure(with: model.mindsets[indexPath.row])
                return cell
            }
        case .todoHeader:
            let cell: DefaultTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: "Todo", isAdd: true, isFolder: true)
            cell.delegate = self
            return cell
        case .todo:
            guard !model.todos.isEmpty else {
                let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.configure(text: "Todo를 추가해 보세요.")
                return cell
            }
            
            let todo = model.todos[indexPath.section - 6]
            let isFolder = todo.type == "FOLDER" && todo.depth == 1
            let isMaxTodo = todo.todos.count == 5
            let isAddTodoCell = !isMaxTodo && (indexPath.row == (todo.todos.count + 1))
            
            if !isFolder {
                let cell: SetTodoCell = tableView.dequeueReusableCell(for: indexPath)
                
                cell.delegate = self
                cell.configure(isType: .task,
                               title: todo.title,
                               startDate: todo.startDate,
                               endDate: todo.endDate,
                               alram: todo.notification)
                
                return cell
            } else if indexPath.row == 0 {
                let cell: DeleteFolderCell = tableView.dequeueReusableCell(for: indexPath)
                
                cell.delegate = self
                cell.configure(title: todo.title)
                
                return cell
            } else if isAddTodoCell {
                let cell: CreateTodoCell = tableView.dequeueReusableCell(for: indexPath)
                
                cell.delegate = self
                
                return cell
            } else {
                let cell: SetTodoCell = tableView.dequeueReusableCell(for: indexPath)
                
                cell.delegate = self
                let isBottom = todo.todos.count == 5 && indexPath.row == 5
                cell.configure(isType: .folder(isBottom ? .bottomRadius : .flat),
                               title: todo.title,
                               startDate: todo.startDate,
                               endDate: todo.endDate,
                               alram: todo.notification)
                
                return cell
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension GoalsCreateVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = SectionType(rawValue: indexPath.section) ?? .todo
        
        switch type {
        case .title:
            return 34.0
        case .category:
            return 94.0
        case .line:
            return 16.0
        case .mindsetHeader:
            return 64.0
        case .mindset:
            return model.mindsets.isEmpty ? 136.0 : UITableView.automaticDimension
        case .todoHeader:
            return 88.0
        case .todo:
            guard !model.todos.isEmpty else { return 136.0 }
            
            let index = indexPath.section - 6
            let todo = model.todos[index]
            let isFolder = todo.type == "FOLDER"
            
            if isFolder {
                let isMaxTodo = todo.todos.count == 5
                let isAddTodoCell = (indexPath.row == (todo.todos.count + 1)) && !isMaxTodo
                if indexPath.row == 0 {
                    return 88.0
                } else if isAddTodoCell {
                    return 72.0
                } else {
                    return 176.0
                }
            } else {
                return 216.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 4
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.section == 4 ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard indexPath.section == 4 else { return }
        
        model.mindsets.remove(at: indexPath.row)
        
        if model.mindsets.isEmpty {
            newGoalTableView.reloadSections(IndexSet(4...4), with: .automatic)
        } else {
            newGoalTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

//MARK: - 목표 제목 설정
extension GoalsCreateVC: NewGoalTitleCellDelegate {
    func textEditingChanged(_ text: String?) {
        guard let text, !text.isEmpty else { return }
        model.title = text
    }
}

//MARK: - 카테고리 코드 설정
extension GoalsCreateVC: CategoriesCellDelegate {
    func selectedCategory(code: String) {
        model.categoryCode = code
        
        LogUtil.d(model)
    }
}

//MARK: - CREATE: Todo Depth 1 & Mindset
extension GoalsCreateVC: DefaultCellDelegate {
    func selectedAdd(type: CreateAddType) {
        switch type {
        case .todo:
            guard model.todos.count < 5 else {
                showPopup(title: "5개까지 생성할 수 있습니다!")
                return
            }
            
            let newTodo = TodosModel(title: "",
                                     type: "TASK",
                                     depth: 1,
                                     orderNumber: model.todos.count,
                                     repetitionType: "NONE",
                                     todos: [])
            model.todos.append(newTodo)
            let section = 5 + model.todos.count
            
            if model.todos.count == 1 {
                newGoalTableView.reloadSections(IndexSet(section...section),
                                                with: .fade)
            } else {
                newGoalTableView.insertSections(IndexSet(section...section),
                                                with: .automatic)
            }
        case .mindset:
            guard model.mindsets.count < 5 else {
                showPopup(title: "5개까지 생성할 수 있습니다!")
                return
            }
            
            let newMindset = GoalsMindset(content: "")
            model.mindsets.append(newMindset)
            
            if model.mindsets.count == 1 {
                newGoalTableView.reloadSections(IndexSet(4...4), with: .fade)
            } else {
                newGoalTableView.insertRows(at: [IndexPath(row: model.mindsets.count - 1, section: 4)],
                                            with: .automatic)
            }
        }
    }
    
    func selectedFolder() {
        guard model.todos.count < 5 else {
            showPopup(title: "5개까지 생성할 수 있습니다!")
            return
        }
        
        let newTodo = TodosModel(title: "",
                                 type: "FOLDER",
                                 depth: 1,
                                 orderNumber: model.todos.count,
                                 todos: [])
        model.todos.append(newTodo)
        let section = 5 + model.todos.count
        
        if model.todos.count == 1 {
            newGoalTableView.reloadSections(IndexSet(section...section),
                                            with: .fade)
        } else {
            newGoalTableView.insertSections(IndexSet(section...section),
                                            with: .automatic)
        }
    }
}

//MARK: - 마인드셋 내용 추가
extension GoalsCreateVC: MindsetTableViewCellDelegate {
    func updateTextViewHeight(_ cell: MindsetTableViewCell, _ textView: UITextView) {
        guard let index = newGoalTableView.indexPath(for: cell)?.row else { return }
        
        model.mindsets[index].content = textView.text
        let contentSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: .infinity))

        if textView.bounds.height != contentSize.height {
            newGoalTableView.contentOffset.y += contentSize.height - textView.bounds.height

            UIView.setAnimationsEnabled(false)
            newGoalTableView.beginUpdates()
            newGoalTableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}

//MARK: - 폴더 및 투두 삭제 && 폴더 및 투두 제목 설정
extension GoalsCreateVC: TodoDelegate {
    func date(for cell: UITableViewCell, startDate: Date, endDate: Date) {
        guard let indexPath = newGoalTableView.indexPath(for: cell) else { return }
        
        let index = indexPath.section - 6
        
        if indexPath.row == 0 {
            model.todos[index].startDate = startDate.dateString
            model.todos[index].endDate = endDate.dateString
        } else {
            model.todos[index].todos[indexPath.row - 1].startDate = startDate.dateString
            model.todos[index].todos[indexPath.row - 1].endDate = endDate.dateString
        }
        
        LogUtil.d(model)
    }
    
    func repeatDate(for cell: UITableViewCell, with days: [String]) {
        guard let indexPath = newGoalTableView.indexPath(for: cell) else { return }
        
        let index = indexPath.section - 6
        
        if indexPath.row == 0 {
            model.todos[index].repetitionType = "WEEK"
            model.todos[index].repetitionParams = days
        } else {
            model.todos[index].todos[indexPath.row - 1].repetitionType = "WEEK"
            model.todos[index].todos[indexPath.row - 1].repetitionParams = days
        }
        
        LogUtil.d(model)
    }
    
    func alaram(for cell: UITableViewCell, with alarm: String) {
        guard let indexPath = newGoalTableView.indexPath(for: cell) else { return }
        
        let index = indexPath.section - 6
        
        if indexPath.row == 0 {
            model.todos[index].notification = alarm
        } else {
            model.todos[index].todos[indexPath.row - 1].notification = alarm
        }
        
        LogUtil.d(model)
    }
    
    func delete(for cell: UITableViewCell) {
        guard let indexPath = newGoalTableView.indexPath(for: cell) else { return }
        
        let index = indexPath.section - 6
        
        if indexPath.row == 0 {
            model.todos.remove(at: index)
            
            if model.todos.isEmpty {
                newGoalTableView.reloadSections(IndexSet(indexPath.section...indexPath.section), with: .fade)
            } else {
                newGoalTableView.deleteSections(IndexSet(indexPath.section...indexPath.section), with: .fade)
            }
        } else {
            let todoCount = model.todos[index].todos.count
            model.todos[index].todos.remove(at: indexPath.item - 1)
            
            if todoCount == 5 {
                newGoalTableView.reloadSections(IndexSet(indexPath.section...indexPath.section), with: .fade)
            } else {
                newGoalTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        LogUtil.d(model)
    }
    
    func title(for cell: UITableViewCell, with text: String) {
        guard let indexPath = newGoalTableView.indexPath(for: cell) else { return }
        
        let index = indexPath.section - 6
        
        if indexPath.row == 0 {
            model.todos[index].title = text
        } else {
            model.todos[index].todos[indexPath.row - 1].title = text
        }
        
        LogUtil.d(model)
    }
}

//MARK: - 폴더 안의 투두 추가
extension GoalsCreateVC: CreateTodoCellDelegate {
    func createTodo(with cell: CreateTodoCell) {
        guard let indexPath = newGoalTableView.indexPath(for: cell) else { return }
        
        let index = indexPath.section - 6
        let todo = model.todos[index]
        let newTodo = ChildTodo(title: "", type: "TASK", depth: 2,
                                orderNumber: todo.todos.count,
                                startDate: "", endDate: "",
                                repetitionType: "NONE")
        model.todos[index].todos.append(newTodo)
        if model.todos[index].todos.count == 5 {
            let scrollIndexPath = IndexPath(row: model.todos[index].todos.count, section: indexPath.section)
            newGoalTableView.reloadSections(IndexSet(indexPath.section ... indexPath.section),
                                            with: .fade)
            newGoalTableView.scrollToRow(at: scrollIndexPath, at: .bottom, animated: true)
        } else {
            let newIndexPath = IndexPath(row: model.todos[index].todos.count, section: indexPath.section)
            let scrollIndexPath = IndexPath(row: model.todos[index].todos.count + 1, section: indexPath.section)
            newGoalTableView.insertRows(at: [newIndexPath],
                                        with: .fade)
            newGoalTableView.scrollToRow(at: scrollIndexPath, at: .bottom, animated: true)
        }
    }
}
