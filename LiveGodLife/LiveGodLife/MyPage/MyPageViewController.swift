//
//  MyPageViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/23.
//

import UIKit
import SnapKit

final class MyPageViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var segmentControlContainerView: UIView!

    private var pageViewController: UIPageViewController!
    private var selectedPageIndex: Int = 0

    private let feedViewController = UIViewController()
    private var emptyView = {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .yellow
        return viewController
    }()
    private lazy var pageViewControllers = [feedViewController, emptyView]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        setupProfileImageView()
        setupNavigationBar()
        setupSegmentView()
        setupPageView()
    }

    private func setupProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.makeBorderGradation(startColor: .green, endColor: .blue)
        profileImageView.image = UIImage(named: "plus")
        profileImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(moveToProfileUpdateView))
        profileImageView.addGestureRecognizer(gesture)
    }

    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.text = "MY PAGE"
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 18)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(moveToSettingView))
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
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
            $0.top.equalTo(segmentControlContainerView.snp.bottom)
        }
        didMove(toParent: self)
    }

    @objc private func moveToSettingView() {
        let settingViewController = SettingViewController()
        navigationController?.pushViewController(settingViewController, animated: true)
    }

    @objc func moveToProfileUpdateView(_ sender: UIButton) {
        let profileUpdateViewController = ProfileUpdateViewController.instance()!
        navigationController?.pushViewController(profileUpdateViewController, animated: true)
    }
}

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
