//
//  TodoDetailVC.swift
//  LiveGodLife
//
//  Created by Ador on 2023/01/04.
//

import UIKit
import SnapKit
import Combine

final class TodoDetailVC: UIViewController {
    //MARK: - Properties
    private var id: Int?
    private var bag = Set<AnyCancellable>()
    private lazy var pageViewControllers: [UIViewController] = [upcomingTaskVC, pastTaskVC]
    
    private var taskInfoView: TaskInfoView!
    private var progressView: TodoProgressView!
    private var segmentControlView: SegmentControlView!
    private var pageVC: UIPageViewController!
    private let upcomingTaskVC = TaskVC()
    private let pastTaskVC = TaskVC()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        requestData()
    }
    
    //MARK: - Functions...
    private func makeUI() {
        view.backgroundColor = .background

        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(moveToBack))
        navigationBar.topItem?.leftBarButtonItem = leftBarButtonItem

        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        navigationBar.topItem?.rightBarButtonItem = rightBarButtonItem

        setupUI()
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
                    self?.upcomingTaskVC.configure(with: afterSchedules, isRepeated: false)
                    self?.pastTaskVC.configure(with: beforeSchedules, isRepeated: false)
                    self?.updateUI()
                } else {
                    self?.upcomingTaskVC.configure(with: afterSchedules, isRepeated: true)
                    self?.pastTaskVC.configure(with: beforeSchedules, isRepeated: true)
                }
            }
            .store(in: &bag)
    }
    
    func configure(id: Int) {
        self.id = id
    }
    
    @objc
    private func moveToBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Make UI
extension TodoDetailVC {
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
        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.setViewControllers([upcomingTaskVC], direction: .forward, animated: true)
        pageVC.dataSource = self
        pageVC.delegate = self

        addChild(pageVC)
        view.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(segmentControlView.snp.bottom)
        }
        didMove(toParent: self)
    }
}

// MARK: - SegmentControlViewDelegate
extension TodoDetailVC: SegmentControlViewDelegate {
    func didTapItem(index: Int) {
        guard index < pageViewControllers.count else { return }

        // FIXME: page item이 두개일 때만 정상동작
        let direction: UIPageViewController.NavigationDirection = index == 0 ? .reverse : .forward
        pageVC.setViewControllers([pageViewControllers[index]], direction: direction, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource
extension TodoDetailVC: UIPageViewControllerDataSource {
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

// MARK: - UIPageViewControllerDelegate
extension TodoDetailVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let previous = previousViewControllers.first, let index = pageViewControllers.firstIndex(of: previous) {
                segmentControlView.deselectedIndex = index
            }
        }
    }
}
