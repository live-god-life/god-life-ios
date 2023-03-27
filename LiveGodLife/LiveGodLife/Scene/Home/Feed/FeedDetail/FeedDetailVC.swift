//
//  FeedDetailVC.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/12.
//

import UIKit
import Combine
import SnapKit
import Kingfisher

final class FeedDetailVC: UIViewController {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    private let repository = DefaultFeedRepository()
    
    let feedID: Int
    private var isBookmarkStatus: Bool = false
    var feed: Feed? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.feedDetailHeaderView.configure(with: self?.feed)
                self?.feedDetailTableView.reloadData()
            }
        }
    }
    private let navigationView = CommonNavigationView()
    private let feedDetailHeaderView = FeedDetailHeaderView(frame: CGRect(x: 0, y: 0,
                                                                          width: UIScreen.main.bounds.width,
                                                                          height: 446.0))
    private lazy var feedDetailTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.separatorColor = .clear
        $0.backgroundColor = .black
        $0.keyboardDismissMode = .onDrag
        $0.alwaysBounceHorizontal = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: .zero, left: .zero,
                                       bottom: 74.0, right: .zero)
        FeedDetailContentsCell.register($0)
        RecommendationCell.register($0)
        MindsetsTableViewCell.register($0)
        CreateTodoCell.register($0)
        EmptyTableViewCell.register($0)
    }
    

    //MARK: - Initializer
    init(feedID: Int) {
        self.feedID = feedID
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Functions...
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(navigationView)
        view.addSubview(feedDetailTableView)
        
        feedDetailTableView.tableHeaderView = feedDetailHeaderView
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        feedDetailTableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        repository.requestFeed(endpoint: .feed(feedID))
            .sink { _ in
            } receiveValue: { [weak self] feed in
                guard let self = self else { return }
                self.feed = feed
            }
            .store(in: &bag)
    }
    
    @objc
    private func didTapBookmark() {
        // TODO: Throttle 필요
        let param: [String: Any] = ["id": feedID, "status": !isBookmarkStatus]
        repository.request(UserAPI.bookmark(param))
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    LogUtil.e(error.localizedDescription)
                case .finished:
                    guard let self else { return }
                    self.isBookmarkStatus = !self.isBookmarkStatus
                    DispatchQueue.main.async {
//                        self.updateBookmark()
                    }
                }
            } receiveValue: { (feed: String?) in

            }
            .store(in: &bag)
    }
}

extension FeedDetailVC: UITableViewDataSource {
    enum FeedCell: Int, CaseIterable {
        case contents
        case recommand
        case mindsets
        case todos
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FeedCell.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = feed else { return .zero }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let feed, let cellType = FeedCell(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch cellType {
            
        case .contents:
            let cell: FeedDetailContentsCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.configure(with: feed)
            
            return cell
        case .recommand:
            let cell: RecommendationCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.delegate = self
            
            return cell
        case .mindsets:
            let cell: MindsetsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            
            cell.configure(with: feed)
            
            return cell
        case .todos:
            return UITableViewCell()
        }
        

    }
}

extension FeedDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let feed, let cellType = FeedCell(rawValue: indexPath.section) else { return .zero }
        
        switch cellType {
        case .contents:
            return FeedDetailContentsCell.height(with: feed)
        case .recommand:
            return 110.0
        case .mindsets:
            return MindsetsTableViewCell.height(with: feed)
        case .todos:
            return .zero
        }
    }
}

extension FeedDetailVC: RecommendationCellDelegate {
    func load() {
        
    }
}
