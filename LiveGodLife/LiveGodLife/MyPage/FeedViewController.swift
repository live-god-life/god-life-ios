//
//  HomeViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/29.
//

import UIKit
import SnapKit
import Combine

final class FeedViewController: UIViewController {

    private var collectionView: UICollectionView!

    private var viewModel = FeedViewModel()
    private var feeds: [Feed] = []

    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = HomeCollectionViewFlowLayout()
        layout.minimumLineSpacing = 32
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: FeedCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        self.collectionView = collectionView

        viewModel.requestFeeds()
            .sink(receiveValue: { [weak self] feeds in
                self?.feeds = feeds
                self?.collectionView.reloadData()
            })
            .store(in: &cancellable)
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 32, height: 330)
    }
}

extension FeedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as! FeedCollectionViewCell
        cell.configure(with: feeds[indexPath.item])
        return cell
    }
}
