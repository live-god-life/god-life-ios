//
//  HomeVC.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/30.
//

import UIKit
import SnapKit
import Combine

final class HomeVC: UIViewController, CategoryFilterViewDelegate {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    private var feeds: [Feed] = []
    private var categories: [Category] = []
    private let repository = DefaultHomeRepository()
    private var isFiltered: Bool = false // TODO: 개선
    
    private let filterHeaderView = FilterHeaderView()
    @IBOutlet private weak var headerView: HomeHeaderView!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }
    
    private func makeUI() {
        view.backgroundColor = .black
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 104, right: 0) // 탭바의 높이만큼 bottom inset
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
    }
    
    private func bind() {
        tableView.delegate = self
        tableView.dataSource = self
        headerView.delegate = self
        filterHeaderView.categoryFilterView.delegate = self
        
        requestTodos()
        requestFeeds()
    }

    @IBAction
    private func detail() {
        guard let id = headerView.id else { return }
        let detailVC = DetailGoalVC(id: id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - Bind Methods
extension HomeVC {
    private func requestTodos() {
        // 오늘 날짜, 최대 5개만, 미완료 투두만
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let today = dateFormatter.string(from: Date())

        let param: [String: Any] = ["date": today, "size": 5, "completionStatus": "false"]
        let todos = repository.requestTodos(endpoint: .todos(param))
        let mindset = repository.requestGoals(endpoint: .mindsets)

        todos.zip(mindset)
            .sink { _ in
            } receiveValue: { [weak self] (todos, goals) in
                self?.headerView.configure(viewModel: HomeHeaderViewModel(todos: todos, goals: goals))
            }
            .store(in: &bag)
    }

    private func requestFeeds() {
        let categories = repository.requestCategory(endpoint: .category)
        let feeds = DefaultFeedRepository().requestFeeds(endpoint: .feeds())
        categories.zip(feeds)
            .sink { _ in
            } receiveValue: { [weak self] (categories, feeds) in
                guard let self = self else { return }
                self.categories = categories
                self.feeds = feeds
                self.update()
            }
            .store(in: &bag)
    }
    
    func filtered(from category: String) {
        let param = ["category": category]
        DefaultFeedRepository().requestFeeds(endpoint: .feeds(param))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    LogUtil.e(error.localizedDescription)
                case .finished:
                    self.isFiltered = true
                }
            } receiveValue: { [weak self] feeds in
                guard let self = self else { return }
                self.feeds = feeds
                self.update()
            }
            .store(in: &bag)
    }

    func updateTodoStatus(id: Int) {
        repository.updateTodoStatus(endpoint: .completeTodo(id))
            .sink { _ in
            } receiveValue: { _ in
                LogUtil.v("complete")
            }
            .store(in: &bag)
    }
}

//MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configure(with: feeds[indexPath.row])
        return cell
    }
}

//MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !isFiltered {
            filterHeaderView.configure(items: categories)
        }
        return filterHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 92
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 362
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let id = feeds[indexPath.row].id
        let feedDetailVC = FeedDetailVC(feedID: id)
        navigationController?.pushViewController(feedDetailVC, animated: true)
    }

    func update() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

//MARK: - FeedTableViewCellDelegate
extension HomeVC: FeedTableViewCellDelegate {
    func bookmark(_ cell: FeedTableViewCell, feedID: Int, status: Bool) {
        let param: [String: Any] = ["id": feedID, "status": status]
        repository.request(UserAPI.bookmark(param))
            .sink { _ in
            } receiveValue: { (feed: String?) in }
            .store(in: &bag)
    }
}

//MARK: - HomeHeaderViewDelegate
extension HomeVC: HomeHeaderViewDelegate {
    func completeTodo(id: Int) {
        repository.request(HomeAPI.completeTodo(id))
            .sink { _ in
            } receiveValue: { (value: Empty) in }
            .store(in: &bag)
    }
}
