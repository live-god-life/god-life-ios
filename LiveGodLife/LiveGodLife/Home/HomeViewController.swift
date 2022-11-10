//
//  FeedViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/30.
//

import UIKit
import SnapKit
import Combine

final class HomeViewController: UIViewController {

    private var collectionView: UICollectionView!

    private var viewModel = FeedViewModel()
    private var feeds: [Feed] = []

    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true

        let layout = HomeCollectionViewFlowLayout()
        layout.minimumLineSpacing = 32
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: FeedCollectionReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeedCollectionReusableView.identifier)
        collectionView.register(UINib(nibName: FeedCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: MindsetCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MindsetCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
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

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 330)
        }
        return CGSize(width: view.frame.width - 32, height: 330)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            // FIXME: top(10) + 라벨(30) + 간격(16) + 카테고리버튼(40) + bottom(24) = 110
            return CGSize(width: collectionView.frame.width, height: 120)
        }
        return .zero
    }
}

extension HomeViewController: UICollectionViewDataSource {

    // TODO: Section 관리하기
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FeedCollectionReusableView.identifier, for: indexPath) as! FeedCollectionReusableView
        return view
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return feeds.count
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MindsetCollectionViewCell.identifier, for: indexPath) as! MindsetCollectionViewCell
//            cell.configure()
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as! FeedCollectionViewCell
        cell.configure(with: feeds[indexPath.item])
        return cell
    }
}
