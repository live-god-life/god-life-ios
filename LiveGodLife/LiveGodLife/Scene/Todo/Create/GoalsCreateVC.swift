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
    var bag = Set<AnyCancellable>()
    var model: CreateGoalsModel
    let viewModel = TodoListViewModel()
    let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "목표추가"
    }
    lazy var newGoalTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.separatorColor = .clear
        $0.backgroundColor = .black
        $0.keyboardDismissMode = .onDrag
        $0.alwaysBounceVertical = false
        $0.alwaysBounceHorizontal = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 46.0, left: .zero,
                                       bottom: 48.0, right: .zero)
        NewGoalTitleCell.register($0)
        CategoriesCell.register($0)
        DefaultTableViewCell.register($0)
    }
    let completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitle("완료", for: .highlighted)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.black, for: .highlighted)
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
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(completeButton.snp.top)
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
}

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
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < 4 else { return .zero }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < 4 else { return UITableViewCell() }
        
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
            return UITableViewCell()
        case .todoHeader:
            return UITableViewCell()
        case .todo:
            return UITableViewCell()
        }
    }
}

extension GoalsCreateVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section < 4,
              let type = SectionType(rawValue: indexPath.section) else { return .zero }
        
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
            return .zero
        case .todoHeader:
            return .zero
        case .todo:
            return .zero
        }
    }
}

extension GoalsCreateVC: NewGoalTitleCellDelegate {
    func textEditingChanged(_ text: String?) {
        guard let text, !text.isEmpty else { return }
        model.title = text
    }
}

extension GoalsCreateVC: CategoriesCellDelegate {
    func selectedCategory(code: String) {
        model.categoryCode = code
    }
}

extension GoalsCreateVC: DefaultCellDelegate {
    func selectedAdd(isTodo: Bool) {
        if isTodo {
            let newTodo = TodosModel(title: "",
                                     type: "TASK",
                                     depth: 1,
                                     orderNumber: model.todos.count,
                                     repetitionType: "NONE")
            model.todos.append(newTodo)
        } else {
            let newMindset = GoalsMindset(content: "")
            model.mindsets.append(newMindset)
        }
        
        LogUtil.d(model)
    }
    
    func selectedFolder() {
        let newTodo = TodosModel(title: "",
                                 type: "FOLDER",
                                 depth: 1,
                                 orderNumber: model.todos.count)
        model.todos.append(newTodo)
    }
}
