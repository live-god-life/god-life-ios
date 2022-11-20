//
//  FeedDetailViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/12.
//

import UIKit
import Combine
import SnapKit

final class FeedDetailViewController: UIViewController {

    private let baseScrollView = UIScrollView()
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let categoryLabel = UILabel()
    private let titleLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let mindsetView = MindsetView()
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    private let todosStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()

    private let repository = DefaultFeedRepository()
    private var cancellable = Set<AnyCancellable>()

    let feedID: Int
    var feed: Feed? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateView()
            }
        }
    }

    init(feedID: Int) {
        self.feedID = feedID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = false

        setupUI()

        repository.requestFeed(endpoint: .feed(feedID))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] feed in
                guard let self = self else { return }
                self.feed = feed
            }
            .store(in: &cancellable)
    }

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

        titleLabel.textColor = .white
        titleLabel.font = .bold(with: 24)
        titleLabel.numberOfLines = 2
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(70)
        }

        let dividerView = UIView()
        dividerView.backgroundColor = .gray
        containerView.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }

        nicknameLabel.textColor = .white
        nicknameLabel.font = .bold(with: 20)
        nicknameLabel.numberOfLines = 1
        containerView.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        containerView.addSubview(contentsStackView)
        contentsStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        let dividerView2 = UIView()
        dividerView2.backgroundColor = .gray
        containerView.addSubview(dividerView2)
        dividerView2.snp.makeConstraints {
            $0.top.equalTo(contentsStackView.snp.bottom).offset(58)
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
        imageView.image = UIImage(named: feed.image)
        categoryLabel.text = feed.category
        titleLabel.text = feed.title
        nicknameLabel.text = feed.user.nickname

        feed.contents.forEach { content in
            let titleLabel = UILabel()
            titleLabel.attributedText = content.title.attributed()
            titleLabel.textColor = .white
            titleLabel.font = .bold(with: 20)
            titleLabel.numberOfLines = 0
            contentsStackView.addArrangedSubview(titleLabel)

            let contentLabel = UILabel()
            contentLabel.attributedText = content.content.attributed()
            contentLabel.textColor = .white
            contentLabel.font = .medium(with: 16)
            contentLabel.numberOfLines = 0
            contentsStackView.addArrangedSubview(contentLabel)
        }

        // 첫 번째 마인드셋을 보여준다
        if let mindset = feed.mindsets.first {
            mindsetView.configure(content: mindset.content)
        }

        feed.todos.forEach { todo in
            let todoView = TodoDropDownView()
            todoView.configure(todo)
            todosStackView.addArrangedSubview(todoView)
        }
    }
}
