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
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 63) // 우선 디자인 가이드대로
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast

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

    var currentIndex: CGFloat = 0
}

extension HomeHeaderView {

    func complete(id: Int) {
        if let index = todos.firstIndex(where: { $0.scheduleID == id }) {
            todos.remove(at: index)
            collectionView.reloadData()
        }
    }
}

extension HomeHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 296, height: collectionView.frame.height)
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

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // https://jintaewoo.tistory.com/33
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemSizeWithSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / itemSizeWithSpacing
        var roundedIndex = round(index)

        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }

        if currentIndex > roundedIndex {
            currentIndex -= 1
            roundedIndex = currentIndex
        } else if currentIndex < roundedIndex {
            currentIndex += 1
            roundedIndex = currentIndex
        }

        offset = CGPoint(x: roundedIndex * itemSizeWithSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
