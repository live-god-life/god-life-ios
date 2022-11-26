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

    private var feeds: [Feed] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadSections(IndexSet(integer: 1))
            }
        }
    }
    private var todos: [Todo] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    private var goals: [Goal] = []
    private var categories: [Category] = []
    private let repository = DefaultHomeRepository()
    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

        requestData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Private

private extension HomeViewController {

    func setupCollectionView() {
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
    }

    func requestData() {
        // TODO: - 오늘 날짜, 최대 5개만, 미완료 투두만
        let param: [String: Any] = ["date": "20221001", "size": 5, "completionStatus": "false"]
        let todos = repository.requestTodos(endpoint: .todos(param))
        let mindset = repository.requestGoals(endpoint: .mindsets)

        todos.zip(mindset)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] (todos, goals) in
                self?.todos = todos
                self?.goals = goals
            }
            .store(in: &cancellable)

        let categories = repository.requestCategory(endpoint: .category)
        let feeds = DefaultFeedRepository().requestFeeds(endpoint: .feeds())
        categories.zip(feeds)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] (categories, feeds) in
                guard let self = self else { return }
                self.categories = categories
                self.feeds = feeds
            }
            .store(in: &cancellable)
    }
}

// MARK: - Delegate

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
        view.setupCategoryItems(categories)
        view.filterView.delegate = self
        return view
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return feeds.count
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 첫번째 섹션: 마인드셋 + 투두
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MindsetCollectionViewCell.identifier, for: indexPath) as! MindsetCollectionViewCell
            cell.configure((todos, goals))
            cell.completionHandler = { [weak self] id in
                self?.updateTodoStatus(id: id)
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as! FeedCollectionViewCell
        cell.configure(with: feeds[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // FIXME
        if indexPath.section == 1 {
            let vc = FeedDetailViewController(feedID: feeds[indexPath.item].id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController: CategoryFilterViewDelegate {

    func filtered(from category: String) {
        // TODO: 로직 논의
    }

    func updateTodoStatus(id: Int) {
        repository.updateTodoStatus(endpoint: .completeTodo(id))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    DispatchQueue.main.async {
                        self?.collectionView.reloadSections(IndexSet(integer: 0))
                    }
                }
            } receiveValue: { _ in
                print("complete")
            }
            .store(in: &cancellable)
    }
}
