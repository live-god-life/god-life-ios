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
    
    var TodoListView: ListViewController<CreateGoalsModel,GoalOfTodoCell> = {
        let node = ListViewController<CreateGoalsModel,GoalOfTodoCell>()
        return node
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        scollView.addSubview(self.TodoListView.view)
        self.view.addSubview(completeButton)
        
        inputGoal.attributedPlaceholder = "목표작성".title26BoldGray6
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
        self.TodoListView.view.snp.makeConstraints {
            $0.top.equalTo(mindSetView.snp.bottom).offset(16)
            $0.left.equalTo(self.view)
            $0.right.equalTo(self.view)
            $0.bottom.equalTo(self.view).offset(-25)
        }
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(self.TodoListView.view.snp.bottom).offset(-30)
            make.height.equalTo(56)
            make.right.equalTo(self.view).offset(-16)
            make.left.equalTo(self.view).offset(16)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 5.0
        
        self.TodoListView.collectionView.collectionViewLayout = layout
        self.TodoListView.collectionView.backgroundColor = .black

        self.TodoListView.collectionView.delegate = self
        self.TodoListView.collectionView.dataSource = self
        self.TodoListView.collectionView.register( CalendarListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarListHeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "목표추가"
        navigationItem.titleView?.backgroundColor = .white
    }
    
    @objc func complete(_ sender: UIButton) {
        let testNumber = Int.random(in: 1...5)
        requestParameter = .init(
            title: "test\(testNumber)",
            categoryCode: "CAREER",
            mindsets: [GoalsMindset(content: "test\(testNumber)")]
           )
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


extension GoalsCreateViewController: UICollectionViewDelegate {
    
}
extension GoalsCreateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemHeightSize = 128.0
        return CGSize(width: self.view.frame.width , height: itemHeightSize)
    }

}

extension GoalsCreateViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
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
//        cell.model = self.listView.model[indexPath.row].todoSchedules
//        cell.dataModel = self.TodoListView.model[indexPath.section].todoSchedules[indexPath.row]
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
