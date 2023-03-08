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
import Then

final class MyPageVC: UIViewController {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "MY PAGE"
        $0.font = .montserrat(with: 20, weight: .semibold)
    }
    private var navigationView = CommonNavigationView().then {
        $0.leftBarButton.isHidden = true
        $0.rightBarButton.setImage(UIImage(named: "setting"), for: .normal)
    }
    private let profileView = ProfileView()
    private var segmentControlView = SegmentControlView(frame: .zero,
                                                        items: [SegmentItem(title: "찜한글"), SegmentItem(title: "내 작성글")])
    private lazy var pageViewControllers = [feedVC, myArticleVC]
    private let emptyLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .regular(with: 16)
        $0.text = "찜한 글이 없어요 👀"
    }

    private lazy var pageVC = UIPageViewController(transitionStyle: .scroll,
                                                   navigationOrientation: .horizontal).then {
        $0.delegate = self
        $0.dataSource = self
        $0.setViewControllers([feedVC], direction: .forward, animated: true)
    }
    private var user: UserModel?

    private let feedVC = FeedVC()
    private var myArticleVC = UIViewController().then {
        $0.view.backgroundColor = .black
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 216, height: 60)))
        label.numberOfLines = 0
        let text = "내 작성글 기능을 준비중입니다.\n다음 업데이트를 기대해주세요."
        label.attributedText = text.attributed()
        label.font = .regular(with: 18)
        label.textColor = .white.withAlphaComponent(0.4)
        $0.view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(160)
        }
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
        requestData()
    }
    
    private func makeUI() {
        addChild(pageVC)
        view.backgroundColor = .black
        
        view.addSubview(navigationView)
        view.addSubview(profileView)
        view.addSubview(segmentControlView)
        view.addSubview(pageVC.view)
        
        navigationView.addSubview(titleLabel)
        feedVC.view.addSubview(emptyLabel)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        profileView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(64)
        }
        segmentControlView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        pageVC.view.snp.makeConstraints {
            $0.top.equalTo(segmentControlView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(30)
        }
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
        
        didMove(toParent: self)
    }
}

// MARK: - Private
private extension MyPageVC {
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
                    self?.profileView.nicknameLabel.text = user.nickname
                    if let image = user.image {
                        self?.profileView.profileImageView.kf.setImage(with: URL(string: image))
                    }
                }
            }
            .store(in: &bag)

        DefaultFeedRepository().requestFeeds(endpoint: .heartFeeds)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] feeds in
                let isHidden = !feeds.isEmpty
                self?.configure(isHidden: isHidden)
                self?.feedVC.configure(with: feeds)
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
    private func bind() {
        navigationView.rightBarButton
            .tapPublisher
            .sink { [weak self] in
                let settingVC = SettingVC()
                self?.navigationController?.pushViewController(settingVC, animated: true)
            }
            .store(in: &bag)
        
        profileView
            .gesture()
            .sink { [weak self] _ in
                guard let self, let profileUpdateVC = ProfileUpdateVC.instance() else {
                    LogUtil.e("ProfileUpdateVC 생성 실패")
                    return
                }
                profileUpdateVC.configure(self.user)
                self.navigationController?.pushViewController(profileUpdateVC, animated: true)
            }
            .store(in: &bag)
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
