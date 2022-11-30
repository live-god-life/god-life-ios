//
//  HomeHeaderView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/29.
//

import UIKit

struct HomeHeaderViewModel {

    let todos: [Todo]
    let goals: [Goal]
}

class HomeHeaderView: UIView, TodoCollectionViewCellDelegate {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private var todos: [Todo.Schedule] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16

        layout.itemSize = CGSize(width: 296, height: 102)
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        collectionView.register(UINib(nibName: TodoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TodoCollectionViewCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func configure(viewModel: HomeHeaderViewModel) {
        self.todos = viewModel.todos.flatMap { $0.schedules }

        DispatchQueue.main.async { [weak self] in
            if let goal = viewModel.goals.randomElement() {
                self?.title.text = goal.title
                self?.content.text = goal.mindsets.randomElement()?.content
            }
            self?.collectionView.reloadData()
        }
    }
}

extension HomeHeaderView {

    // Todo 완료 체크 버튼
    func complete(id: Int) {
        if let index = todos.firstIndex(where: { $0.scheduleID == id }) {
            todos.remove(at: index)
            print(index)
            
        }
    }
}

extension HomeHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 40), height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.identifier, for: indexPath) as! TodoCollectionViewCell
        cell.configure(todos[indexPath.item])
        cell.delegate = self
        return cell
    }
}
