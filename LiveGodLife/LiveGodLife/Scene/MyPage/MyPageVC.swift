//
//  MyPageVC.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/23.
//

import UIKit
import Combine
import Kingfisher
import SnapKit

final class MyPageVC: UIViewController {
    //MARK: - Properties
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var profileImageContainerView: UIView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var segmentControlContainerView: UIView!

    private var bag = Set<AnyCancellable>()
    private lazy var pageViewControllers = [feedVC, myArticleVC]
    private var segmentControlView: SegmentControlView!
    private let emptyLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .regular(with: 16)
        $0.text = "찜한 글이 없어요 👀"
    }

    private var pageVC: UIPageViewController!
    private var user: UserModel?

    private let feedVC = FeedVC()
    private var myArticleVC = UIViewController().then {
        $0.view.backgroundColor = .background
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        label.numberOfLines = 0
        let text = "내 작성글 기능을 준비중입니다.\n다음 업데이트를 기대해주세요❤️"
        label.attributedText = text.attributed()
        label.font = .regular(with: 16)
        label.textColor = .white
        $0.view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
        setupNavigationBar()
        requestData()
    }
    
    private func makeUI() {
        view.backgroundColor = .background

        setupUI()

        feedVC.view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
    }
}

// MARK: - Private
private extension MyPageVC {
    private func setupUI() {
        setupNavigationBar()
        setupProfileImageView()
        setupNavigationBar()
        setupSegmentView()
        setupPageView()
    }

    @objc
    private func moveToSettingView() {
        let settingVC = SettingVC()
        navigationController?.pushViewController(settingVC, animated: true)
    }

    @objc
    private func moveToProfileUpdateView(_ sender: UIButton) {
        let profileUpdateVC = ProfileUpdateVC.instance()!
        profileUpdateVC.configure(user)
        navigationController?.pushViewController(profileUpdateVC, animated: true)
    }

    private func requestData() {
        DefaultUserRepository().fetchProfile(endpoint: .user)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    // 프로필 조회 실패
                    LogUtil.e(error)
                case .finished:
                    LogUtil.v("finished")
                }
            } receiveValue: { [weak self] user in
                self?.user = user
                DispatchQueue.main.async {
                    self?.nicknameLabel.text = user.nickname
                    if let image = user.image {
                        self?.profileImageView.kf.setImage(with: URL(string: image))
                    }
                }
            }
            .store(in: &bag)

        DefaultFeedRepository().requestFeeds(endpoint: .heartFeeds)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] feeds in
                let isHidden = !feeds.isEmpty
                self?.configure(isHidden: isHidden)
                self?.feedVC.updateView(with: feeds)
            })
            .store(in: &bag)
    }

    func configure(isHidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.emptyLabel.isHidden = isHidden
        }
    }
}

// MARK: - Setup
extension MyPageVC {
    private func setupProfileImageView() {
        let radius = profileImageContainerView.frame.height / 2
        profileImageContainerView.layer.cornerRadius = radius
        profileImageContainerView.makeBorderGradation(startColor: .green, endColor: .blue, radius: radius)
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
        segmentControlView = SegmentControlView(frame: segmentControlContainerView.bounds, items: items)
        segmentControlView.delegate = self
        segmentControlContainerView.addSubview(segmentControlView)
    }

    private func setupPageView() {
        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.setViewControllers([feedVC], direction: .forward, animated: true)
        pageVC.dataSource = self
        pageVC.delegate = self

        addChild(pageVC)
        view.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(segmentControlContainerView.snp.bottom).offset(30)
        }
        didMove(toParent: self)
    }
}

// MARK: - Delegate
extension MyPageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let current = pageViewControllers.firstIndex(of: viewController) else { return nil }
        let previous = current - 1
        if previous < 0 {
            return nil
        }
        return pageViewControllers[previous]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let current = pageViewControllers.firstIndex(of: viewController) else { return nil }
        let next = current + 1
        if next == pageViewControllers.count {
            return nil
        }
        return pageViewControllers[next]
    }
}

extension MyPageVC: SegmentControlViewDelegate {
    func didTapItem(index: Int) {
        guard index < pageViewControllers.count else { return }

        // FIXME: page item이 두개일 때만 정상동작
        let direction: UIPageViewController.NavigationDirection = index == 0 ? .reverse : .forward
        pageVC.setViewControllers([pageViewControllers[index]], direction: direction, animated: true)
    }
}

extension MyPageVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let previous = previousViewControllers.first, let index = pageViewControllers.firstIndex(of: previous) {
                segmentControlView.deselectedIndex = index
            }
        }
    }
}
