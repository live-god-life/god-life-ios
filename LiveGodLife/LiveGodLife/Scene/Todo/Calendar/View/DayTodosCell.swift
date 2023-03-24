//
//  DayTodosCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/29.
//

import UIKit
import Combine
import CombineCocoa

protocol DayTodosCellDelegate: AnyObject {
    func selectDetail(id: Int)
}

final class DayTodosCell: UICollectionViewCell {
    // MARK: - Properties
    weak var delegate: DayTodosCellDelegate?
    private let viewModel = TodoListViewModel()
    private var list: MainCalendarModel?
    private var snapshot: TodosSnapshot!
    private var dataSource: TodosDataSource!
    private lazy var todoCollectionView = UICollectionView(frame: .zero,
                                                           collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        DayTodoCell.register($0)
    }
    private let titleLabel = UILabel().then {
        $0.font = .regular(with: 16)
        $0.textColor = .white
    }
    private let infoImageView = UIImageView().then {
        $0.image = UIImage(named: "arrow-right")
    }
    private let headerButton = UIButton()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        bind()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions...
    private func makeUI() {
        backgroundColor = .black
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoImageView)
        contentView.addSubview(headerButton)
        contentView.addSubview(todoCollectionView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(24)
        }
        infoImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.left.equalTo(titleLabel.snp.right).offset(4)
            $0.size.equalTo(16)
        }
        headerButton.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.right.equalTo(infoImageView.snp.right)
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        todoCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        configureDataSource()
    }
    
    private func bind() {
        headerButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let id = self?.list?.goalId else { return }
                self?.delegate?.selectDetail(id: id)
            }
            .store(in: &viewModel.bag)
    }

    func configure(with list: MainCalendarModel) {
        self.list = list
        self.titleLabel.text = list.title
        
        updateDataSnapshot(with: list.todoSchedules ?? [])
    }
    
    static func height(with list: MainCalendarModel) -> CGFloat {
        guard let todos = list.todoSchedules,
              !todos.isEmpty else { return .zero }
        
        let count = CGFloat(todos.count)
        
        var height = 36.0
        height += count * 80.0
        height += (count - 1.0) * 16.0
        
        return height
    }
}

// MARK: - DiffableDataSource
extension DayTodosCell {
    typealias TodosSnapshot = NSDiffableDataSourceSnapshot<TodoListViewModel.Section, SubCalendarModel>
    typealias TodosDataSource = UICollectionViewDiffableDataSource<TodoListViewModel.Section, SubCalendarModel>
    
    private func configureDataSource() {
        dataSource = TodosDataSource(collectionView: todoCollectionView) { collectionView, indexPath, todo in
            let cell: DayTodoCell = collectionView.dequeueReusableCell(for: indexPath)
            let status = self.viewModel.completedList[todo.todoScheduleId ?? -1] ?? false
            
            cell.delegate = self
            cell.configure(with: todo,
                           completionStatus: status)
            
            return cell
        }
    }
    
    private func updateDataSnapshot(with todos: [SubCalendarModel]) {
        snapshot = TodosSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(todos, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DayTodosCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 16.0
        flowLayout.minimumInteritemSpacing = 16.0
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = dataSource.itemIdentifier(for: indexPath)?.todoId else { return }
        
        let todoType = dataSource.itemIdentifier(for: indexPath)?.repetitionType ?? ""
        let todoDetailVC = TodoDetailVC(type: todoType == "NONE" ? .dDay : .todo, id: id)
        UIApplication.topViewController()?.navigationController?.pushViewController(todoDetailVC, animated: true)
    }
}

// MARK: - DayTodoCellDelegate
extension DayTodosCell: DayTodoCellDelegate {
    func selectedTodo(id: Int?, isCompleted: Bool) {
        guard let id else { return }
        
        viewModel.completedList.updateValue(isCompleted, forKey: id)
        viewModel.input.requestStatus.send((id, isCompleted))
    }
}
