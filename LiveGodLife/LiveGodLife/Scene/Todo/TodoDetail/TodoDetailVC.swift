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
    private var taskType: TaskType = .todo
    private var viewModel: TaskInfoViewModel? {
        didSet {
            self.taskInfoView.configure(with: viewModel)
        }
    }
    private var schedules = [[TodoScheduleViewModel]]()
    private var navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "TODO 상세"
    }
    private let afterVC = TaskVC()
    private let beforeVC = TaskVC()
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                               navigationOrientation: .horizontal).then {
        $0.delegate = self
        $0.dataSource = self
        $0.setViewControllers([afterVC], direction: .forward, animated: true)
    }
    private var taskInfoView = TaskInfoView()
    private lazy var todoTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.separatorColor = .clear
        $0.backgroundColor = .black
        $0.isScrollEnabled = false
        $0.alwaysBounceHorizontal = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .zero
        TasksCell.register($0)
    }
    let headerView = PageSelectionView()
    private let emptyView = UIView().then {
        $0.backgroundColor = .black
    }
    private var value: CGFloat = 44
    private let min: CGFloat = 44.0 - 368.0
    private let max: CGFloat = 44.0
    private var oldContentOffset = CGPoint.zero
    private var dragInitialY: CGFloat = 0
    private var dragPreviousY: CGFloat = 0
    
    //MARK: - Life Cycle
    init(id: Int) {
        self.id = id
        
        super.init(nibName: nil, bundle: nil)
        
        requestData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        configure()
    }
    
    //MARK: - Functions...
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(taskInfoView)
        view.addSubview(headerView)
        view.addSubview(pageViewController.view)
        view.addSubview(navigationView)
        view.addSubview(emptyView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
        taskInfoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(44)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(368)
        }
        headerView.snp.makeConstraints {
            $0.top.equalTo(taskInfoView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        emptyView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(navigationView.snp.top)
        }
    }
    
    private func configure() {
        afterVC.tableView.delegate = self
        afterVC.tableView.dataSource = self
        beforeVC.tableView.delegate = self
        beforeVC.tableView.dataSource = self
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.move(sender:)))
        taskInfoView.isUserInteractionEnabled = true
        taskInfoView.addGestureRecognizer(gesture)
        let gesture2 = UIPanGestureRecognizer(target: self, action: #selector(self.move(sender:)))
        headerView.isUserInteractionEnabled = true
        headerView.addGestureRecognizer(gesture2)
    }
    
    @objc func move(sender: UIPanGestureRecognizer) {
        var dragYDiff : CGFloat
        
        switch sender.state {
            
        case .began:
            dragInitialY = sender.location(in: self.view).y
            dragPreviousY = dragInitialY
        case .changed:
            let dragCurrentY = sender.location(in: self.view).y
            dragYDiff = dragPreviousY - dragCurrentY
            dragPreviousY = dragCurrentY
            
            value -= dragYDiff
            
            if value < min {
                value = min
            } else if value > max {
                value = max
            }
                
            taskInfoView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(value)
            }
        default: return
        }
    }

    private func requestData() {
        guard let id = id else { return }

        let detail: AnyPublisher<TaskViewModel, APIError> = DefaultHomeRepository().request(HomeAPI.todoDetail(id))
        let afterSchedules: AnyPublisher<[TodoScheduleViewModel], APIError> = DefaultHomeRepository().request(HomeAPI.todoSchedules(id, ["criteria": "after"]))
        let beforeSchedules: AnyPublisher<[TodoScheduleViewModel], APIError> = DefaultHomeRepository().request(HomeAPI.todoSchedules(id, ["criteria": "before"]))

        detail.zip(afterSchedules, beforeSchedules)
            .receive(on: DispatchQueue.main)
            .sink { detail in
                LogUtil.d(detail)
            } receiveValue: { [weak self] (detail, afterSchedules, beforeSchedules) in
                self?.taskType = detail.repetitionType == .none ? .dDay : .todo
                self?.viewModel = TaskInfoViewModel(data: detail)
                self?.schedules = [afterSchedules, beforeSchedules]
                self?.afterVC.configure(with: afterSchedules, isRepeated: true)
                self?.beforeVC.configure(with: beforeSchedules, isRepeated: true)
                self?.headerView.configure(with: detail.repetitionType == .none ? .dDay : .todo, isNext: true)
            }
            .store(in: &bag)
    }
    
    @objc
    private func moveToBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Make UI
extension TodoDetailVC {
    enum TaskType {
        case todo
        case dDay
    }
}

extension TodoDetailVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController == afterVC ? beforeVC : afterVC
        self.oldContentOffset = vc.tableView.contentOffset
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController == afterVC ? beforeVC : afterVC
        self.oldContentOffset = vc.tableView.contentOffset
        return vc
    }
}

extension TodoDetailVC: UIPageViewControllerDelegate {}

extension TodoDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard schedules.count > 1 else { return .zero }
        let model = tableView == afterVC.tableView ? schedules[0] : schedules[1]
        
        return model.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard schedules.count > 1 else { return UITableViewCell() }
        
        let model = tableView == afterVC.tableView ? schedules[0] : schedules[1]
        let cell: TaskTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(model[indexPath.section], isRepeated: true)
        
        return cell
    }

    // section header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard schedules.count > 1 else { return nil }
        
        let model = tableView == afterVC.tableView ? schedules[0] : schedules[1]
        
        return model[section].scheduleDate
    }

    // 섹션 헤더의 타이틀 색상 변경
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
            header.textLabel?.font = .regular(with: 16)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var delta = scrollView.contentOffset.y - oldContentOffset.y
        
        delta = delta > 2 ? 1.0 : delta < -2 ? -1.0 : delta
        
//        print(delta)
        
        if delta > 0,
           value > min,
            scrollView.contentOffset.y > 0 {
            
//            dragDirection = .Up
//            innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
            
            value -= delta
            
            if value < min {
                value = min
            } else if value > max {
                value = max
            }
            
            taskInfoView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(value)
            }
            
            print(value)
            
            scrollView.contentOffset.y -= delta
        }
        
        if delta < 0,
           value < max,
            scrollView.contentOffset.y < 0 {
            value -= delta
            
            if value < min {
                value = min
            } else if value > max {
                value = max
            }
            
            taskInfoView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(value)
            }
            
            print(value)
            
            scrollView.contentOffset.y -= delta
        }


        
        oldContentOffset = scrollView.contentOffset
    }
}
