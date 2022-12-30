//
//  GoalsCreateViewController.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/12/16.
//

import Foundation
import UIKit

class GoalsCreateViewController: UIViewController {
    var requestParameter: CreateGoalsModel?
    let inputGoal = UITextField()
    let textView = UIView()
    
    enum GoalType: Int {
        case task
        case folder
        
        var name: String {
            switch self {
            case .folder:
                return "FOLDER"
            case .task:
                return "TASK"
            }
        }
    }
    
    lazy var mindSetView: UIView = {
        let view = UIView()
        let title = UILabel()
        let addButton = UIButton()
      
        let leftImageView = UIImageView()
        let rightImageView = UIImageView()
        let mindSetTextLabel = UILabel()
        
        
        mindSetTextLabel.textColor = .white
        mindSetTextLabel.numberOfLines = 0
        mindSetTextLabel.text = "사는건 레벨업이 아닌 스펙트럼을 넓히는거란 얘길 들었다. 어떤 말보다 용기가 된다."
        leftImageView.image = UIImage(named: "leftQuote")
        rightImageView.image = UIImage(named: "rightQuote")
        
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        
        self.textView.addSubview(leftImageView)
        self.textView.addSubview(mindSetTextLabel)
        self.textView.addSubview(rightImageView)
        
        view.addSubview(self.textView)
        
        leftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(13)
            make.height.equalTo(13)
        }
        mindSetTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalTo(leftImageView.snp.right).offset(15)
            make.right.equalTo(rightImageView.snp.left).offset(15)
            make.bottom.equalToSuperview().offset(-24)
        }
        rightImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.right.equalToSuperview().offset(-26)
            make.width.equalTo(13)
            make.height.equalTo(13)
        }
        self.textView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.bottom.right.equalToSuperview().offset(-16)
            
        }
        
        return view
    }()
    
    var todoListView: ListViewController<TodosModel,GoalOfTodoCell> = {
        let node = ListViewController<TodosModel,GoalOfTodoCell>()
        return node
    }()

    var todoHeaderView: UIView = {
        let view = UIView()
        let titleLabel = UILabel()
        let addTodoButton = UIButton()
        let addFolderButton = UIButton()
        
        view.addSubview(titleLabel)
        view.addSubview(addTodoButton)
        view.addSubview(addFolderButton)
        
        titleLabel.attributedText = "Todo".title16White
        
        addTodoButton.setImage(UIImage(named: "addTodo"), for: .normal)
        addTodoButton.addTarget(self, action: #selector(add(_:)), for: .touchUpInside)
        addTodoButton.tag = GoalType.task.rawValue
        addFolderButton.setImage(UIImage(named: "addFolder"), for: .normal)
        addFolderButton.addTarget(self, action: #selector(add(_:)), for: .touchUpInside)
        addFolderButton.tag = GoalType.folder.rawValue
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        addTodoButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(32)
            make.height.equalTo(32)
            make.right.equalToSuperview()
        }
        addFolderButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(32)
            make.height.equalTo(32)
            make.right.equalTo(addTodoButton.snp.left).offset(-8)
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let testNumber = Int.random(in: 1...5)
        requestParameter = .init(
            title: "test\(testNumber)",
            categoryCode: "CAREER",
            mindsets: [GoalsMindset(content: "test\(testNumber)")],
            todos: []
           )
        self.view.backgroundColor = .black
        let inputGoalsImage = UIImageView()
        let spaceView = UIView()
        let completeButton = UIButton()
        let scollView = UIScrollView()
        
       
        
        spaceView.backgroundColor = .darkGray
        self.view.addSubview(scollView)
        self.view.addSubview(inputGoal)
        self.view.addSubview(spaceView)
        scollView.addSubview(mindSetView)
        scollView.addSubview(todoHeaderView)
        scollView.addSubview(self.todoListView.view)
        self.view.addSubview(completeButton)
        
        inputGoal.attributedPlaceholder = "목표작성".title26BoldGray6
        inputGoal.textColor = .gray6
        inputGoal.font = .title26Bold
        
        completeButton.addTarget(self, action: #selector(complete(_:)), for: .touchUpInside)
        completeButton.layer.cornerRadius = 20
        completeButton.backgroundColor = .green
        completeButton.setTitle("완료", for: .normal)
        
        inputGoal.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(46)
            make.centerX.equalTo(self.view)
            make.height.equalTo(40)
        }
        
        spaceView.snp.makeConstraints { make in
            make.top.equalTo(self.inputGoal.snp.bottom).offset(36)
            make.left.right.equalTo(self.view)
            make.height.equalTo(16)
        }
        
        scollView.snp.makeConstraints { make in
            make.top.equalTo(spaceView).offset(32)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        mindSetView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            
        }
        
        todoHeaderView.snp.makeConstraints { make in
            make.top.equalTo(mindSetView.snp.bottom).offset(16)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            make.height.equalTo(30)
        }
        self.todoListView.view.snp.makeConstraints {
            $0.top.equalTo(todoHeaderView.snp.bottom).offset(17)
            $0.left.equalTo(self.view)
            $0.right.equalTo(self.view)
            $0.bottom.equalTo(self.view).offset(-25)
        }
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(self.todoListView.view.snp.bottom).offset(-30)
            make.height.equalTo(56)
            make.right.equalTo(self.view).offset(-16)
            make.left.equalTo(self.view).offset(16)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 5.0
        
        self.todoListView.collectionView.collectionViewLayout = layout
        self.todoListView.collectionView.backgroundColor = .black

        self.todoListView.collectionView.delegate = self
        self.todoListView.collectionView.dataSource = self
        self.todoListView.collectionView.register( CalendarListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarListHeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "목표추가"
        navigationItem.titleView?.backgroundColor = .white
    }
    
    @objc func complete(_ sender: UIButton) {
        let testNumber = Int.random(in: 1...5)
        
        var todos:[TodosModel] = []
        for index in 0...testNumber {
             var todo = TodosModel(
                title: "test\(testNumber)",
                type: "CAREER",
                depth: index,
                orderNumber: index)
            var childTodos:[ChildTodo] = []
            for subIdx in 1...3 {
                let subTodo = ChildTodo(
                    title:  "test Child \(testNumber)",
                    type: "test Child \(testNumber)",
                    depth: subIdx,
                    orderNumber: subIdx,
                    startDate: Date.today,
                    endDate: Date.today,
                    repetitionType:  "DAY",
                    repetitionParams: nil,
                    notification: Date.today.date?.hour24Represent
                )
                childTodos.append(subTodo)
            }
            todo.todos = childTodos
            todos.append(todo)
        }
        requestParameter?.todos = todos
        
        guard let parameter = requestParameter else {
            return
        }
        NetworkManager().provider.request(.addGoals(parameter)) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let result):
                do {

                    let json = try result.mapJSON()
                    let jsonData = json as? [String:Any] ?? [:]
                    print(jsonData)
                } catch(let err) {
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

extension GoalsCreateViewController {
    @objc func add(_ sender: UIButton) {
        let type = GoalType(rawValue: sender.tag) ?? .task
        let testNumber = Int.random(in: 1...5)

        var todo = TodosModel(
           title: "test\(testNumber)",
           type: "CAREER",
           depth: testNumber,
           orderNumber: testNumber,
           todos: []
        )
        let subTodo = ChildTodo(
            title:  "test Child \(testNumber)",
            type: type.name,
            depth: testNumber,
            orderNumber: testNumber,
            startDate: Date.today,
            endDate: Date.today,
            repetitionType:  "DAY",
            repetitionParams: nil,
            notification: Date.today.date?.hour24Represent
        )
        todo.todos?.append(subTodo)
        requestParameter?.todos?.append(todo)
        todoListView.model = requestParameter?.todos ?? []
        todoListView.collectionView.reloadData()
    }
}


extension GoalsCreateViewController: UICollectionViewDelegate {
    
}
extension GoalsCreateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let type = "FOLDER"
        let type = self.todoListView.model[indexPath.section].todos?[indexPath.row].type ?? "FOLDER"
        let itemHeightSize = type == "FOLDER" ? 176.0 : 152.0
        return CGSize(width: self.view.frame.width , height: itemHeightSize)
    }

}

extension GoalsCreateViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.todoListView.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalOfTodoCell.identifier, for: indexPath) as? GoalOfTodoCell else {
            return UICollectionViewCell()
        }
        cell.model = self.todoListView.model[indexPath.row]
        cell.dataModel = self.todoListView.model[indexPath.section].todos?[indexPath.row]
        cell.button[0].addTarget(self, action: #selector(cell.change(_:)), for: .touchUpInside)
        cell.button[1].addTarget(self, action: #selector(cell.change(_:)), for: .touchUpInside)
        cell.button[2].addTarget(self, action: #selector(cell.change(_:)), for: .touchUpInside)

        cell.setUpModel()
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CalendarListHeaderView", for: indexPath)
//            if let headerView = headerView as? CalendarListHeaderView {
//                if self.TodoListView.model.count > 0 {
//                    headerView.titleLabel.text = self.listView.model[indexPath.section].title
//                    headerView.delegate = self
//                }
//            }
            return headerView
        default:
            assert(false, "")
        }
        return UICollectionReusableView()
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: self.view.frame.width, height: 30)
//    }
}

extension GoalsCreateViewController: TodoListHeaderViewDelegate {
    func calendarListHeaderView(_ view: TodoListHeaderView, go: Bool) {
        // 상세화면 처리하기
    }}
protocol TodoListHeaderViewDelegate: AnyObject {
    func calendarListHeaderView(_ view: TodoListHeaderView, go: Bool)
}
class TodoListHeaderView: UICollectionReusableView {
    
    /// 버튼 액션 델리게이트
    weak var delegate: TodoListHeaderViewDelegate? = nil
    var titleLabel = UILabel()
    lazy var detailButton: UIButton = {
        let button = UIButton()
//        button.setImage(#imageLiteral(resourceName: "icon-close-20.pdf"), for: .normal)
//        button.addTarget(self, action: #selector(self.closeAction(_:)), for: .touchUpInside)
        return button
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
    }
    
    func setUpView() {
        self.backgroundColor = .black
        self.titleLabel.textColor = .white
        
        self.addSubview(titleLabel)
        self.addSubview(detailButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(24)
        }
        detailButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalToSuperview()
            make.height.equalTo(24)
        }
    }
    // MARK: - Button Action
    @objc func closeAction(_ sender: UIButton) {
//        delegate?.sideMenuHeaderView(self, selectedClose: true)
    }
}
