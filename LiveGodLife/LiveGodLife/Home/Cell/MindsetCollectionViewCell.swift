//
//  MindsetCollectionViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/09.
//

import UIKit

struct MindsetViewModel {

    let title: String
    let content: String
}

// FIXME: MindsetCollectionViewCell 네이밍
final class MindsetCollectionViewCell: UICollectionViewCell {

    static var identifier = "MindsetCollectionViewCell"

    @IBOutlet weak var emptyTodoTextLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private var goals: [Goal] = [] {
        didSet {
            // TODO: 데이터 없을 때 예외처리
            if let goal = goals.randomElement() {
                title.text = goal.title
                if let mindset = goal.mindsets.randomElement() {
                    content.text = mindset.content
                }
            }
        }
    }
    private var todos: [Todo.Schedule] = []

    weak var delegate: TodoCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.register(UINib(nibName: TodoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TodoCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func configure(_ data: (todos: [Todo], goals: [Goal])) {
        self.todos = data.todos.flatMap { $0.schedules }
        self.goals = data.goals
        emptyTodoTextLabel.isHidden = !todos.isEmpty
    }
}

// MARK: - Todo Collection View

extension MindsetCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 40), height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.identifier, for: indexPath) as! TodoCollectionViewCell
        cell.delegate = delegate
        cell.configure(todos[indexPath.item])
        return cell
    }
}
