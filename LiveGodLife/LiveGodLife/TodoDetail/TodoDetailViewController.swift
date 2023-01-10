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
    private var progressView: TodoProgressView?
    private var segmentControlView: SegmentControlView!
    private var pageViewController: UIPageViewController!
    private let upcomingTaskViewController = TaskViewController()
    private let pastTaskViewController = TaskViewController()
    private lazy var pageViewControllers: [UIViewController] = [upcomingTaskViewController, pastTaskViewController]

    private var cancellable = Set<AnyCancellable>()

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
        DefaultHomeRepository().request(HomeAPI.todoDetail("2"))
            .receive(on: DispatchQueue.main)
            .sink {
                print($0)
            } receiveValue: { (data: TaskViewModel) in
                if data.repetitionType == .none {

                } else {
                    self.upcomingTaskViewController.configure(with: data)
                    self.taskInfoView.configure(TaskInfoViewModel(data: data))
                    self.progressView?.configure(completedCount: data.completedCount, totalCount: data.totalCount)
                }
            }
            .store(in: &cancellable)

        DefaultHomeRepository().request(HomeAPI.todoSchedules("2", ["criteria": "before"]))
            .receive(on: DispatchQueue.main)
            .sink {
                print($0)
            } receiveValue: { (data: [TodoScheduleViewModel]) in
                print(data)
                self.upcomingTaskViewController.configure(with: data)
            }
            .store(in: &cancellable)
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
        // TODO: TODO의 repetitionType에 따라 highlightColor 지정 로직 변경
        let items = [SegmentItem(title: "앞으로 일정"), SegmentItem(title: "지난 일정")]
        segmentControlView = SegmentControlView(frame: CGRect(origin: .zero,
                                                              size: CGSize(width: view.frame.width, height: 56)),
                                                items: items, highlightColor: .blue)
        segmentControlView.delegate = self
        view.addSubview(segmentControlView)

        if let progressView = progressView {
            segmentControlView.snp.makeConstraints {
                $0.top.equalTo(progressView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(56)
            }
            return
        }
        segmentControlView.snp.makeConstraints {
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
            $0.top.equalTo(segmentControlView.snp.bottom).offset(30)
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