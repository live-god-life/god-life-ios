//
//  FeedViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/30.
//

import UIKit
import SnapKit
import Combine

final class FeedViewController: UIViewController {

    class Section: Hashable {

        var items: [Feed]

        init(items: [Feed]) {
            self.items = items
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(items)
        }

        static func == (lhs: Section, rhs: Section) -> Bool {
            lhs.items == rhs.items
        }
    }

    private var collectionView: UICollectionView!
    private var sections: [Section] = []
    private var viewModel = FeedViewModel()
    private lazy var dataSource = makeDataSource()

    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 32
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 330)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: FeedCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        self.collectionView = collectionView

        viewModel.requestFeeds()
            .sink(receiveValue: { [weak self] feeds in
                self?.sections = [Section(items: feeds)]
                self?.updateSnapshot()
            })
            .store(in: &cancellable)
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Feed> {
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, feed in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as! FeedCollectionViewCell
                cell.configure(with: feed)
                return cell
            })
    }

    private func updateSnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Feed>()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
