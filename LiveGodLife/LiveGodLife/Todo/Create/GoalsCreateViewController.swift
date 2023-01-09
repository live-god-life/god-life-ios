//
//  GoalsCreateViewController.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/12/16.
//

import Foundation
import UIKit

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

struct DisplayTodo:Codable {
    var type:String
    var index:Int
    var taskModel: ChildTodo?
    var folderModel: TodosModel?
    
}



class GoalsCreateViewController: UIViewController {
//    var requestParameter: CreateGoalsModel?
   
    
    let inputGoal = UITextField()
    let mindSetTextField = UITextField()
    let textView = UIView()

    
    lazy var mindSetView: UIView = {
        let view = UIView()
        let title = UILabel()
        let addButton = UIButton()
      
        let leftImageView = UIImageView()
        let rightImageView = UIImageView()
        
        
        mindSetTextField.textColor = .white
        mindSetTextField.text = "사는건 레벨업이 아닌 스펙트럼을 넓히는거란 얘길 들었다. 어떤 말보다 용기가 된다."
        leftImageView.image = UIImage(named: "leftQuote")
        rightImageView.image = UIImage(named: "rightQuote")
        
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        
        self.textView.addSubview(leftImageView)
        self.textView.addSubview(mindSetTextField)
        self.textView.addSubview(rightImageView)
        
        view.addSubview(self.textView)
        
        leftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(13)
            make.height.equalTo(13)
        }
        mindSetTextField.snp.makeConstraints { make in
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
    
    var todoListView: ListViewController<DisplayTodo,GoalOfTodoCell> = {
        let node = ListViewController<DisplayTodo,GoalOfTodoCell>()
        return node
    }()

//    lazy var todoHeaderView: UIView = {
//        let view = UIView()
//        let titleLabel = UILabel()
//        let addTodoButton = UIButton()
//        let addFolderButton = UIButton()
//
//        view.addSubview(titleLabel)
//        view.addSubview(addTodoButton)
//        view.addSubview(addFolderButton)
//
//        titleLabel.attributedText = "Todo".title16White
//
//        addTodoButton.setImage(UIImage(named: "addTodo"), for: .normal)
//        addTodoButton.addTarget(self, action: #selector(addTASK(_:)), for: .touchUpInside)
//        addTodoButton.tag = GoalType.task.rawValue
//        addFolderButton.setImage(UIImage(named: "addFolder"), for: .normal)
//        addFolderButton.addTarget(self, action: #selector(addFolder(_:)), for: .touchUpInside)
//        addFolderButton.tag = GoalType.folder.rawValue
//
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.left.equalToSuperview()
//        }
//        addTodoButton.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.width.equalTo(32)
//            make.height.equalTo(32)
//            make.right.equalToSuperview()
//        }
//        addFolderButton.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.width.equalTo(32)
//            make.height.equalTo(32)
//            make.right.equalTo(addTodoButton.snp.left).offset(-8)
//        }
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        let completeButton = UIButton()
        
        completeButton.addTarget(self, action: #selector(complete(_:)), for: .touchUpInside)
        completeButton.layer.cornerRadius = 20
        completeButton.backgroundColor = .green
        completeButton.setTitle("완료", for: .normal)
        
        self.view.addSubview(self.todoListView.view)
        self.view.addSubview(completeButton)
        

        self.todoListView.view.snp.makeConstraints {
//            $0.top.equalTo(todoHeaderView.snp.bottom).offset(17)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(17)
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
        self.todoListView.collectionView.register(GoalOfTodoTaskCell.self, forCellWithReuseIdentifier: "GoalOfTodoTaskCell")
        self.todoListView.collectionView.register(GoalOfEmptyCell.self, forCellWithReuseIdentifier: "GoalOfEmptyCell")
        self.todoListView.collectionView.register(GoalOfTodoCell.self, forCellWithReuseIdentifier: "GoalOfTodoCell")

        self.todoListView.collectionView.delegate = self
        self.todoListView.collectionView.dataSource = self
        self.todoListView.collectionView.register( TodoListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TodoListHeaderView")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "목표추가"
        navigationItem.titleView?.backgroundColor = .white
    }
    
    @objc func complete(_ sender: UIButton) {
        let testNumber = Int.random(in: 1...5)
        guard let title = self.inputGoal.text else {
            //TODO: 메세지 출력하기
            return
        }
        guard let mindSetText = self.mindSetTextField.text else {
            //TODO: 메세지 출력하기
            return
        }
        
        TodoListHeaderView.requestParameter.updateValue(title, forKey: "title")
        TodoListHeaderView.requestParameter.updateValue("CAREER", forKey: "categoryCode")
        TodoListHeaderView.requestParameter.updateValue(mindSetText, forKey: "mindsets")
        var todos:[Any] = []
        TodoListHeaderView.requestTodos.forEach { (key: Int, value: Any) in
            todos.append(value)
        }
        TodoListHeaderView.requestParameter.updateValue(todos, forKey: "todos")
        
        NetworkManager().provider.request(.addGoals(TodoListHeaderView.requestParameter)) { response in
            switch response {
            case .success(let result):
                do {

                    let json = try result.mapJSON()
                    let jsonData = json as? [String:Any] ?? [:]
                    print(jsonData)
                } catch(let err) {
                    print(err)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

extension GoalsCreateViewController {
    
}


extension GoalsCreateViewController: UICollectionViewDelegate {
    
}
extension GoalsCreateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        guard self.todoListView.model.count != 0  else {
            return CGSize(width: self.view.frame.width, height: 30)
            
        }
        let type = self.todoListView.model[indexPath.item].type
        
        var cellTypeHeight = 0.0
        
        switch type {
        case "FOLDER":
            cellTypeHeight = Double(todoListView.model[indexPath.item].folderModel?.todos?.count == 0 ? 195 : 195)
//            cellTypeHeight = self.todoListView.model.count/2 == 0 ? 195.0 : 350
        case "TASK":
            cellTypeHeight = 152.0
        default:
            cellTypeHeight = 0.0
        }
        
//        let itemHeightSize = ? 30.0 : cellTypeHeight

        return CGSize(width: self.view.frame.width , height: cellTypeHeight)
    }

}

extension GoalsCreateViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        print(self.viewModel.count == 0 ? 1 : self.viewModel.count)
//        return self.viewModel.count == 0 ? 1 : 0
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return TodoListHeaderView.viewModel.count == 0 ? 1 : TodoListHeaderView.viewModel.count
//        return self.viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        guard let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalOfEmptyCell.identifier, for: indexPath) as? GoalOfEmptyCell else {
            return UICollectionViewCell()
        }
        guard let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalOfTodoCell.identifier, for: indexPath) as? GoalOfTodoCell else {
            return UICollectionViewCell()
        }
        guard let Taskcell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalOfTodoTaskCell.identifier, for: indexPath) as? GoalOfTodoTaskCell else {
            return UICollectionViewCell()
        }

        if self.todoListView.model.count == 0 {
            return emptyCell
        }
        
        print(indexPath.item)
        let index = indexPath.item
        switch self.todoListView.model[indexPath.item].type {
        case "TASK":
//            print(self.todoListView.model)
            Taskcell.model = self.todoListView.model[index]
            Taskcell.dataModel = self.todoListView.model[index].taskModel
            Taskcell.setUpModel()
            return Taskcell
        case "FOLDER":
            print(self.todoListView.model)
            folderCell.model = self.todoListView.model[index]
            folderCell.dataModel = self.todoListView.model[index].folderModel
            folderCell.setUpModel()
            return folderCell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodoListHeaderView", for: indexPath)
            if let headerView = headerView as? TodoListHeaderView {
//                if self.TodoListView.model.count > 0 {
//                    headerView.titleLabel.text = self.listView.model[indexPath.section].title
//                    headerView.delegate = self
//                }
                headerView.todoListView = self.todoListView
            }
            return headerView
        default:
            assert(false, "")
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            let width: CGFloat = collectionView.frame.width
            let height: CGFloat = 350
            return CGSize(width: width, height: height)
        }
}

extension GoalsCreateViewController: TodoListHeaderViewDelegate {
    func calendarListHeaderView(_ view: TodoListHeaderView, go: Bool) {
        // 상세화면 처리하기
    }}
protocol TodoListHeaderViewDelegate: AnyObject {
    func calendarListHeaderView(_ view: TodoListHeaderView, go: Bool)
}
class TodoListHeaderView: UICollectionReusableView {
    static var viewModel: [DisplayTodo] = []
    static var requestParameter: [String:Any] = [:]
    static var requestTodos:[Int:Any] = [:]
    static var modelIndex = 0
    var todoListView: ListViewController<DisplayTodo,GoalOfTodoCell>?
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
    
    let inputGoal = UITextField()
    let mindSetTextField = UITextField()
    let textView = UIView()

    
    lazy var mindSetView: UIView = {
        let view = UIView()
        let title = UILabel()
        let addButton = UIButton()
      
        let leftImageView = UIImageView()
        let rightImageView = UIImageView()
        
        
        mindSetTextField.textColor = .white
        mindSetTextField.text = "사는건 레벨업이 아닌 스펙트럼을 넓히는거란 얘길 들었다. 어떤 말보다 용기가 된다."
        leftImageView.image = UIImage(named: "leftQuote")
        rightImageView.image = UIImage(named: "rightQuote")
        
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        
        self.textView.addSubview(leftImageView)
        self.textView.addSubview(mindSetTextField)
        self.textView.addSubview(rightImageView)
        
        view.addSubview(self.textView)
        
        leftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(13)
            make.height.equalTo(13)
        }
        mindSetTextField.snp.makeConstraints { make in
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
    

    lazy var todoHeaderView: UIView = {
        let view = UIView()
        let titleLabel = UILabel()
        let addTodoButton = UIButton()
        let addFolderButton = UIButton()
        
        view.addSubview(titleLabel)
        view.addSubview(addTodoButton)
        view.addSubview(addFolderButton)
        
        titleLabel.attributedText = "Todo".title16White
        
        addTodoButton.setImage(UIImage(named: "addTodo"), for: .normal)
        addTodoButton.addTarget(self, action: #selector(addTASK(_:)), for: .touchUpInside)
        addTodoButton.tag = GoalType.task.rawValue
        addFolderButton.setImage(UIImage(named: "addFolder"), for: .normal)
        addFolderButton.addTarget(self, action: #selector(addFolder(_:)), for: .touchUpInside)
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
    func setUpView() {
        self.backgroundColor = .black
//        self.titleLabel.textColor = .white
        
        let inputGoalsImage = UIImageView()
        let spaceView = UIView()
        
        spaceView.backgroundColor = .darkGray
        self.addSubview(inputGoal)
        self.addSubview(spaceView)
        self.addSubview(mindSetView)
        self.addSubview(todoHeaderView)
        inputGoal.attributedPlaceholder = "목표작성".title26BoldGray6
        inputGoal.textColor = .gray6
        inputGoal.font = .title26Bold
        
        
        inputGoal.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(46)
            make.centerX.equalTo(self)
            make.height.equalTo(40)
        }
        
        spaceView.snp.makeConstraints { make in
            make.top.equalTo(self.inputGoal.snp.bottom).offset(36)
            make.left.right.equalTo(self)
            make.height.equalTo(16)
        }
        
        
        mindSetView.snp.makeConstraints { make in
            make.top.equalTo(spaceView.snp.bottom).offset(32)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
            
        }
        
        todoHeaderView.snp.makeConstraints { make in
            make.top.equalTo(mindSetView.snp.bottom).offset(16)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
            make.height.equalTo(30)
        }
    }
    // MARK: - Button Action
    @objc func closeAction(_ sender: UIButton) {
//        delegate?.sideMenuHeaderView(self, selectedClose: true)
    }
    
    @objc func addFolder(_ sender: UIButton) {
        let type = GoalType(rawValue: sender.tag) ?? .folder
        let testNumber = Int.random(in: 1...5)
        
        var todo = TodosModel(
           title: "test\(testNumber)",
           type: type.name,
           depth: testNumber,
           orderNumber: testNumber,
           todos: []
        )
        
//        let subTodo = ChildTodo(
//            title:  "test Child \(testNumber)",
//            type: type.name,
//            depth: testNumber,
//            orderNumber: testNumber,
//            startDate: Date.today,
//            endDate: Date.today,
//            repetitionType:  "DAY",
//            repetitionParams: nil,
//            notification: Date.today.date?.hour24Represent
//        )
        TodoListHeaderView.viewModel.append(.init(type: type.name, index: TodoListHeaderView.modelIndex, taskModel: nil, folderModel: todo))
        self.todoListView?.model = TodoListHeaderView.viewModel
        self.todoListView?.collectionView.reloadData()

        // request 용 todos 생성
        TodoListHeaderView.requestTodos.updateValue(todo, forKey: TodoListHeaderView.modelIndex)
        TodoListHeaderView.modelIndex = TodoListHeaderView.modelIndex + 1
    }
    @objc func addTASK(_ sender: UIButton) {
        let type = GoalType(rawValue: sender.tag) ?? .task
        let testNumber = Int.random(in: 1...5)
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
        
        TodoListHeaderView.viewModel.append(.init(type: type.name, index: TodoListHeaderView.modelIndex, taskModel: subTodo))
        self.todoListView?.model = TodoListHeaderView.viewModel
        
        self.todoListView?.collectionView.reloadData()

        // request 용 todos 생성
        TodoListHeaderView.requestTodos.updateValue(subTodo, forKey: TodoListHeaderView.modelIndex)
        TodoListHeaderView.modelIndex = TodoListHeaderView.modelIndex + 1

    }
}
