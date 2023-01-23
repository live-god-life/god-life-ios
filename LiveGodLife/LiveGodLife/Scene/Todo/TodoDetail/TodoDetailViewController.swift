//
//  DDayDetailViewController.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/04.
//

import UIKit
import SnapKit
import Combine

class TodoDetailViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!

    private var taskInfoView: TaskInfoView!
    private var progressView: TodoProgressView!
    private var segmentControlView: SegmentControlView!
    private var pageViewController: UIPageViewController!
    private let upcomingTaskViewController = TaskViewController()
    private let pastTaskViewController = TaskViewController()
    private lazy var pageViewControllers: [UIViewController] = [upcomingTaskViewController, pastTaskViewController]

    private var bag = Set<AnyCancellable>()

    private var id: Int?

    func configure(id: Int) {
        self.id = id
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(moveToBack))
        navigationBar.topItem?.leftBarButtonItem = leftBarButtonItem

        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        navigationBar.topItem?.rightBarButtonItem = rightBarButtonItem

        setupUI()
        requestData()
    }

    @objc private func moveToBack() {
        navigationController?.popViewController(animated: true)
    }

    private func requestData() {
        guard let id = id else { return }

        let detail: AnyPublisher<TaskViewModel, APIError> = DefaultHomeRepository().request(HomeAPI.todoDetail(id))
        let afterSchedules: AnyPublisher<[TodoScheduleViewModel], APIError> = DefaultHomeRepository().request(HomeAPI.todoSchedules(id, ["criteria": "after"]))
        let beforeSchedules: AnyPublisher<[TodoScheduleViewModel], APIError> = DefaultHomeRepository().request(HomeAPI.todoSchedules(id, ["criteria": "before"]))

        detail.zip(afterSchedules, beforeSchedules)
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] (detail, afterSchedules, beforeSchedules) in
                self?.taskInfoView.configure(TaskInfoViewModel(data: detail))
                self?.progressView.configure(completedCount: detail.completedCount, totalCount: detail.totalCount)
                if detail.repetitionType == .none {
                    self?.upcomingTaskViewController.configure(with: afterSchedules, isRepeated: false)
                    self?.pastTaskViewController.configure(with: beforeSchedules, isRepeated: false)
                    self?.updateUI()
                } else {
                    self?.upcomingTaskViewController.configure(with: afterSchedules, isRepeated: true)
                    self?.pastTaskViewController.configure(with: beforeSchedules, isRepeated: true)
                }
            }
            .store(in: &bag)
    }

    private func setupUI() {
        setupTaskInfoView()
        setupProgressView()
        setupSegmentControlView()
        setupPageView()
    }

    private func setupTaskInfoView() {
        taskInfoView = TaskInfoView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 150)))
        view.addSubview(taskInfoView)
        taskInfoView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
    }

    private func setupProgressView() {
        let progressView = TodoProgressView()
        view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.top.equalTo(taskInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        self.progressView = progressView
    }

    private func setupSegmentControlView() {
        let items = [SegmentItem(title: "앞으로 일정"), SegmentItem(title: "지난 일정")]
        segmentControlView = SegmentControlView(frame: CGRect(origin: .zero,
                                                              size: CGSize(width: view.frame.width, height: 56)),
                                                items: items)
        segmentControlView.delegate = self
        view.addSubview(segmentControlView)
        segmentControlView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
    }

    private func updateUI() {
        self.progressView.isHidden = true
        segmentControlView.configure(highlightColor: .blue)
        segmentControlView.snp.remakeConstraints {
            $0.top.equalTo(taskInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
    }

    private func setupPageView() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.setViewControllers([upcomingTaskViewController], direction: .forward, animated: true)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(segmentControlView.snp.bottom)
        }
        didMove(toParent: self)
    }
}

extension TodoDetailViewController: SegmentControlViewDelegate {

    func didTapItem(index: Int) {
        guard index < pageViewControllers.count else { return }

        // FIXME: page item이 두개일 때만 정상동작
        let direction: UIPageViewController.NavigationDirection = index == 0 ? .reverse : .forward
        pageViewController.setViewControllers([pageViewControllers[index]], direction: direction, animated: true)
    }
}

// MARK: - Delegate
extension TodoDetailViewController: UIPageViewControllerDataSource {

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

extension TodoDetailViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let previous = previousViewControllers.first, let index = pageViewControllers.firstIndex(of: previous) {
                segmentControlView.deselectedIndex = index
            }
        }
    }
}
