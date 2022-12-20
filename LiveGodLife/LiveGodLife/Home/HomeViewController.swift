//
//  FeedViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/30.
//

import UIKit
import SnapKit
import Combine

final class HomeViewController: UIViewController, CategoryFilterViewDelegate {

    @IBOutlet weak var headerView: HomeHeaderView!
    @IBOutlet weak var tableView: UITableView!

    private let filterHeaderView = FilterHeaderView()

    private let repository = DefaultHomeRepository()
    private var feeds: [Feed] = []
    private var categories: [Category] = []

    private var cancellable = Set<AnyCancellable>()

    // TODO: 개선
    private var isFiltered: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        filterHeaderView.categoryFilterView.delegate = self

        setupTableView()

        requestTodos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true

        requestFeeds()
    }
}

// MARK: - Private

private extension HomeViewController {

    func setupTableView() {
        tableView.backgroundColor = .background
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        // 탭바의 높이만큼 bottom inset
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 104, right: 0)
    }

    func requestTodos() {
        // 오늘 날짜, 최대 5개만, 미완료 투두만
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let today = dateFormatter.string(from: Date())

        let param: [String: Any] = ["date": today, "size": 5, "completionStatus": "false"]
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
                self?.headerView.configure(viewModel: HomeHeaderViewModel(todos: todos, goals: goals))
            }
            .store(in: &cancellable)
    }

    func requestFeeds() {
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
                self.update()
            }
            .store(in: &cancellable)
    }
}

extension HomeViewController {

    func filtered(from category: String) {
        let param = ["category": category]
        DefaultFeedRepository().requestFeeds(endpoint: .feeds(param))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    self.isFiltered = true
                }
            } receiveValue: { [weak self] feeds in
                guard let self = self else { return }
                self.feeds = feeds
                self.update()
            }
            .store(in: &cancellable)
    }

    func updateTodoStatus(id: Int) {
        repository.updateTodoStatus(endpoint: .completeTodo(id))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    DispatchQueue.main.async {
                        //
                    }
                }
            } receiveValue: { _ in
                print("complete")
            }
            .store(in: &cancellable)
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configure(with: feeds[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !isFiltered {
            filterHeaderView.configure(items: categories)
        }
        return filterHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let id = feeds[indexPath.row].id
        let vc = FeedDetailViewController(feedID: id)
        navigationController?.pushViewController(vc, animated: true)
    }

    func update() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension HomeViewController: FeedTableViewCellDelegate {

    func bookmark(feedID: Int, status: Bool) {
        let param: [String: Any] = ["id": feedID, "status": status]
        repository.request(UserAPI.bookmark(param))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { (feed: String?) in

            }
            .store(in: &cancellable)
    }
}
