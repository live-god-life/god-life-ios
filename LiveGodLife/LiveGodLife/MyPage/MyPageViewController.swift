//
//  MyPageViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/23.
//

import UIKit
import Combine
import SnapKit

final class MyPageViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var segmentControlContainerView: UIView!

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .regular(with: 16)
        label.text = "찜한 글이 없어요 👀"
        return label
    }()

    private var pageViewController: UIPageViewController!
    private var selectedPageIndex: Int = 0

    private let feedViewController = FeedViewController()
    private var myArticleViewController = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        label.numberOfLines = 0
        let text = "내 작성글 기능을 준비중입니다.\n다음 업데이트를 기대해주세요❤️"
        label.attributedText = text.attributed()
        label.font = .regular(with: 16)
        label.textColor = .white
        viewController.view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
        return viewController
    }()
    private lazy var pageViewControllers = [feedViewController, myArticleViewController]

    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        feedViewController.view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
        setupNavigationBar()
        requestData()
    }
}

// MARK: - Private
private extension MyPageViewController {

    func setupUI() {
        setupNavigationBar()
        setupProfileImageView()
        setupNavigationBar()
        setupSegmentView()
        setupPageView()
    }

    @objc func moveToSettingView() {
        let settingViewController = SettingViewController()
        navigationController?.pushViewController(settingViewController, animated: true)
    }

    @objc func moveToProfileUpdateView(_ sender: UIButton) {
        let profileUpdateViewController = ProfileUpdateViewController.instance()!
        navigationController?.pushViewController(profileUpdateViewController, animated: true)
    }

    func requestData() {
        DefaultUserRepository().updateProfile(endpoint: .user)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    // 프로필 조회 실패
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] user in
                DispatchQueue.main.async {
                    self?.nicknameLabel.text = user.nickname
                }
            }
            .store(in: &cancellable)

        DefaultFeedRepository().requestFeeds(endpoint: .heartFeeds)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            }, receiveValue: { [weak self] feeds in
                let isHidden = !feeds.isEmpty
                self?.update(isHidden: isHidden)
                self?.feedViewController.updateView(with: feeds)
            })
            .store(in: &cancellable)
    }

    func update(isHidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.label.isHidden = isHidden
        }
    }
}

// MARK: - Setup
extension MyPageViewController {

    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.makeBorderGradation(startColor: .green, endColor: .blue)
        profileImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveToProfileUpdateView))
        profileImageView.addGestureRecognizer(gesture)
    }

    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.text = "MY PAGE"
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 18)
        let leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationBar.topItem?.leftBarButtonItem = leftBarButtonItem

        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(moveToSettingView))
        navigationItem.backButtonTitle = ""
        navigationBar.topItem?.rightBarButtonItem = rightBarButtonItem
    }

    private func setupSegmentView() {
        let items = [SegmentItem(title: "찜한글"), SegmentItem(title: "내 작성글")]
        let segmentView = SegmentControlView(frame: segmentControlContainerView.bounds, items: items)
        segmentView.delegate = self
        segmentControlContainerView.addSubview(segmentView)
    }

    private func setupPageView() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.setViewControllers([feedViewController], direction: .forward, animated: true)
        pageViewController.dataSource = self

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(segmentControlContainerView.snp.bottom).offset(30)
        }
        didMove(toParent: self)
    }
}

// MARK: - Delegate
extension MyPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let current = pageViewControllers.firstIndex(of: viewController) else { return nil }
        let previous = current - 1
        if previous < 0 {
            return nil
        }
        selectedPageIndex = current
        return pageViewControllers[previous]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let current = pageViewControllers.firstIndex(of: viewController) else { return nil }
        let next = current + 1
        if next == pageViewControllers.count {
            return nil
        }
        selectedPageIndex = current
        return pageViewControllers[next]
    }
}

extension MyPageViewController: SegmentControlViewDelegate {

    func didTapItem(index: Int) {
        guard index < pageViewControllers.count else { return }

        let direction: UIPageViewController.NavigationDirection = selectedPageIndex < index ? .forward : .reverse
        pageViewController.setViewControllers([pageViewControllers[index]], direction: direction, animated: true)
    }
}
