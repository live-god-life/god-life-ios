//
//  HomeHeaderView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/29.
//

import UIKit

protocol HomeHeaderViewDelegate: AnyObject {
    func completeTodo(id: Int)
}

final class HomeHeaderView: UIView {
    //MARK: - Properties
    weak var delegate: HomeHeaderViewDelegate?
    var currentIndex: CGFloat = 0
    private var todos: [Todo.Schedule] = []
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        makeUI()
    }
    
    private func makeUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16

        layout.itemSize = CGSize(width: 296, height: 102)
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 63) // 우선 디자인 가이드대로
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast

        collectionView.register(UINib(nibName: TodoCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: TodoCollectionViewCell.id)

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

extension HomeHeaderView: TodoCollectionViewCellDelegate {
    func complete(id: Int) {
        if let index = todos.firstIndex(where: { $0.scheduleID == id }) {
            todos.remove(at: index)
            collectionView.reloadData()
            delegate?.completeTodo(id: id)
        }
    }
}

//MARK: - UICollectionView DataSource & DelegateFlowLayout
extension HomeHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 296, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TodoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
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
