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

    private var feeds: [Feed] = []

    private var bag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 32
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: FeedCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .background
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 104, right: 0)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        self.collectionView = collectionView
    }

    func updateView(with feeds: [Feed]) {
        self.feeds = feeds
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
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
        cell.delegate = self
        return cell
    }
}

extension FeedViewController: FeedCollectionViewCellDelegate {

    func bookmark(feedID: Int, status: Bool) {
        let param: [String: Any] = ["id": feedID, "status": status]
        DefaultMyPageRepository().request(UserAPI.bookmark(param))
            .sink { _ in
            } receiveValue: { (feed: String?) in }
            .store(in: &bag)
    }
}
