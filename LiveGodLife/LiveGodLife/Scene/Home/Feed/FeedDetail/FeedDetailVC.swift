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
                self?.updateView()
            }
        }
    }
    private let baseScrollView = UIScrollView()
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let categoryLabel = UILabel()
    private let titleLabel = UILabel()
    private let todoCountLabel = UILabel()
    private let todoScheduleDay = UILabel()
    private let bookmarkButton = UIButton()
    private let nicknameLabel = UILabel()
    private let mindsetView = MindsetView()
    private let userProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .green
    }
    private let calendarImageView = UIImageView().then {
        $0.image = UIImage(named: "calendar")
        $0.contentMode = .scaleAspectFit
    }
    private let contentsContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 32
    }
    private let todosStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 24
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
    
    //MARK: - Functions...
    private func makeUI() {
        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = false

        setupUI()
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
                        self.updateBookmark()
                    }
                }
            } receiveValue: { (feed: String?) in

            }
            .store(in: &bag)
    }
}

private extension FeedDetailVC {
    private func setupUI() {
        // baseScrollView
        baseScrollView.contentSize = containerView.bounds.size
        view.addSubview(baseScrollView)
        baseScrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        // containerStackView
        baseScrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(view.safeAreaLayoutGuide)
        }

        // imageView
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(250)
        }
        imageView.contentMode = .scaleAspectFit

        // categoryLabel
        categoryLabel.textColor = .BBBBBB
        categoryLabel.font = .regular(with: 14)
        containerView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(24)
        }

        // titleLabel
        titleLabel.textColor = .BBBBBB
        titleLabel.font = .bold(with: 24)
        titleLabel.numberOfLines = 2
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(70)
        }

        let image = UIImageView(image: UIImage(named: "lightning"))
        image.contentMode = .scaleAspectFit
        containerView.addSubview(image)
        image.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(24)
        }
        todoCountLabel.text = "0 List"
        todoCountLabel.textColor = .green
        todoCountLabel.font = .montserrat(with: 16, weight: .bold)
        containerView.addSubview(todoCountLabel)
        todoCountLabel.snp.makeConstraints {
            $0.leading.equalTo(image.snp.trailing).offset(8)
            $0.centerY.equalTo(image.snp.centerY)
        }

        containerView.addSubview(calendarImageView)
        calendarImageView.snp.makeConstraints {
            $0.leading.equalTo(todoCountLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(image.snp.centerY)
        }
        todoScheduleDay.textColor = .green
        todoScheduleDay.font = .montserrat(with: 16, weight: .bold)
        containerView.addSubview(todoScheduleDay)
        todoScheduleDay.snp.makeConstraints {
            $0.leading.equalTo(calendarImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(image.snp.centerY)
        }

        bookmarkButton.addTarget(self, action: #selector(didTapBookmark), for: .touchUpInside)
        bookmarkButton.setBackgroundImage(UIImage(named: "bookmark"), for: .selected)
        bookmarkButton.setBackgroundImage(UIImage(named: "bookmark_disable"), for: .normal)
        containerView.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().inset(16)
        }

        let dividerView = UIView()
        dividerView.backgroundColor = .gray
        containerView.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.top.equalTo(bookmarkButton.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }

        // user
        containerView.addSubview(userProfileImageView)
        userProfileImageView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(40)
        }

        nicknameLabel.textColor = .white
        nicknameLabel.font = .bold(with: 20)
        nicknameLabel.numberOfLines = 1
        containerView.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userProfileImageView.snp.centerY)
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(8)
        }

        containerView.addSubview(contentsContainerView)
        contentsContainerView.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

//        contentsContainerView.addSubview(contentsStackView)
//        contentsStackView.snp.makeConstraints {
//            $0.top.leading.trailing.bottom.equalToSuperview()
//        }

        let dividerView2 = UIView()
        dividerView2.backgroundColor = .gray
        containerView.addSubview(dividerView2)
        dividerView2.snp.makeConstraints {
            $0.top.equalTo(contentsContainerView.snp.bottom).offset(58)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }

        let recommandTitle = UILabel()
        recommandTitle.text = "추천 리스트"
        recommandTitle.textColor = .white
        recommandTitle.font = .bold(with: 26)
        containerView.addSubview(recommandTitle)
        recommandTitle.snp.makeConstraints {
            $0.top.equalTo(dividerView2.snp.bottom).offset(69)
            $0.leading.equalToSuperview().inset(24)
        }

        let mindsetLabel = UILabel()
        mindsetLabel.text = "마인드셋"
        mindsetLabel.textColor = .white
        mindsetLabel.font = .bold(with: 20)
        containerView.addSubview(mindsetLabel)
        mindsetLabel.snp.makeConstraints {
            $0.top.equalTo(recommandTitle.snp.bottom).offset(19)
            $0.leading.equalToSuperview().inset(24)
        }

        containerView.addSubview(mindsetView)
        mindsetView.snp.makeConstraints {
            $0.top.equalTo(mindsetLabel.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(120)
        }

        let todoLabel = UILabel()
        todoLabel.text = "Todo"
        todoLabel.textColor = .white
        todoLabel.font = .bold(with: 20)
        containerView.addSubview(todoLabel)
        todoLabel.snp.makeConstraints {
            $0.top.equalTo(mindsetView.snp.bottom).offset(49)
            $0.leading.equalToSuperview().inset(24)
        }

        containerView.addSubview(todosStackView)
        todosStackView.snp.makeConstraints {
            $0.top.equalTo(todoLabel.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }

    private func updateView() {
        guard let feed = feed else {
            // TODO: error handle
            return
        }
        let url = URL(string: feed.image)
        imageView.kf.setImage(with: url)
        categoryLabel.text = feed.category
        titleLabel.text = feed.title
        todoCountLabel.text = "\(feed.todoCount) List"
        todoScheduleDay.text = "\(feed.todoScheduleDay) DAY"
        bookmarkButton.isSelected = feed.isBookmark
        nicknameLabel.text = feed.user.nickname

        isBookmarkStatus = feed.isBookmark

        feed.contents.forEach { content in
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.spacing = 8

            let titleLabel = UILabel()
            titleLabel.attributedText = content.title.attributed()
            titleLabel.textColor = .white
            titleLabel.font = .bold(with: 18)
            titleLabel.numberOfLines = 0
            stackView.addArrangedSubview(titleLabel)

            let contentLabel = UILabel()
            contentLabel.attributedText = content.content.attributed()
            contentLabel.textColor = .white
            contentLabel.font = .medium(with: 16)
            contentLabel.numberOfLines = 0
            stackView.addArrangedSubview(contentLabel)

            contentsContainerView.addArrangedSubview(stackView)
        }

        // 첫 번째 마인드셋을 보여준다
        if let mindset = feed.mindsets.first {
            mindsetView.configure(content: mindset.content)
            mindsetView.makeBorderGradation(startColor: .green, endColor: .blue, radius: 16)
        }

        feed.todos.forEach { todo in
            let todoView = TodoDropDownView()
            todoView.configure(todo)
            todosStackView.addArrangedSubview(todoView)
        }
    }

    private func updateBookmark() {
        bookmarkButton.isSelected = isBookmarkStatus
    }
}
