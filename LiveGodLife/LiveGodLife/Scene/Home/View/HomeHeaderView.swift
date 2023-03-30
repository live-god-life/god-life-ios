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
    var id: Int?
    private var todos: [Todo.Schedule] = []
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var content: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var contentHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        makeUI()
    }
    
    private func makeUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16

        layout.itemSize = CGSize(width: 296, height: 108)
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
                self?.id = goal.id
                self?.title.text = goal.title
                let contentString = goal.mindsets.randomElement()?.content
                self?.content.text = contentString
                let numberOfLines = UILabel.countLines(font: .semiBold(with: 28)!, text: contentString ?? "", width: UIScreen.main.bounds.width - 92.0)
                self?.contentHeightConstraint.constant = numberOfLines < 2 ? 40 : 80
                self?.frame.size.height = numberOfLines < 2 ? 338 : 378
                self?.layoutIfNeeded()
            }
            self?.collectionView.reloadData()
        }
    }
}

extension HomeHeaderView: TodoCollectionViewCellDelegate {
    func complete(id: Int) {
        delegate?.completeTodo(id: id)
    }
}

//MARK: - UICollectionView DataSource & DelegateFlowLayout
extension HomeHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 296.0, height: 108.0)
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
