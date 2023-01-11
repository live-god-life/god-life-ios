//
//  TodoMainTabViewController.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/28.
//

import UIKit
import SnapKit
import Then
import Combine
import CombineCocoa

enum TodoMainTab: CaseIterable {
    case calendar
    case mindset
    case goal
    
    var title: String {
        switch self {
        case .calendar:
            return "캘린더"
        case .mindset:
            return "마인드셋"
        case .goal:
            return "목표"
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .calendar:
            return CalendarListVC()
        case .mindset:
            return MindsetsVC()
        case .goal:
            return GoalsVC()
        }
    }
    
    var tabBarItem : UITabBarItem {
        let tabBarItem = UITabBarItem()
        tabBarItem.title = self.title
        switch self {
        case .calendar:
            fallthrough
        case .mindset:
            fallthrough
        case .goal:
            return tabBarItem
        }
    }
    
    var configured: UIViewController {
        let viewController = self.viewController
        viewController.title = self.title
        viewController.hidesBottomBarWhenPushed = false
        viewController.tabBarItem = self.tabBarItem
        return viewController
    }
}

protocol TodoTabBarViewDelegate: AnyObject {
    func setViewController(with index: Int)
}

final class TodoMainTabBarController: UITabBarController {
    //MARK: - Properties
    private var bag = Set<AnyCancellable>()
    private var commonButton = UIButton().then {
        $0.backgroundColor = .black
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 50
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    private lazy var calendarButton = UIButton().then {
        $0.tag = 0
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 17
        $0.setTitle("캘린더", for: .normal)
        $0.titleLabel?.font = .bold(with: 14)
        $0.setTitleColor(.gray2, for: .normal)
        $0.setTitleColor(.background, for: .selected)
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setBackgroundColor(.green, for: .selected)
        $0.addTarget(self, action: #selector(seletedView(_:)), for: .touchUpInside)
    }
    private lazy var mindsetButton = UIButton().then {
        $0.tag = 1
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 17
        $0.setTitle("마인드셋", for: .normal)
        $0.titleLabel?.font = .bold(with: 14)
        $0.setTitleColor(.gray2, for: .normal)
        $0.setTitleColor(.background, for: .selected)
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setBackgroundColor(.green, for: .selected)
        $0.addTarget(self, action: #selector(seletedView(_:)), for: .touchUpInside)
    }
    private lazy var goalButton = UIButton().then {
        $0.tag = 2
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 17
        $0.setTitle("목표", for: .normal)
        $0.titleLabel?.font = .bold(with: 14)
        $0.setTitleColor(.gray2, for: .normal)
        $0.setTitleColor(.background, for: .selected)
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setBackgroundColor(.green, for: .selected)
        $0.addTarget(self, action: #selector(seletedView(_:)), for: .touchUpInside)
    }
    private let titleLabel = UILabel().then {
        $0.text = "TODO"
        $0.textColor = .white
        $0.font = .montserrat(with: 20, weight: .bold)
    }
    private lazy var tabBarView = UIStackView().then {
        $0.spacing = .zero
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.layoutMargins = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        $0.isLayoutMarginsRelativeArrangement = true
        
        $0.addArrangedSubview(self.calendarButton)
        $0.addArrangedSubview(self.mindsetButton)
        $0.addArrangedSubview(self.goalButton)
        
        $0.layer.cornerRadius = 23
        $0.layer.masksToBounds = true
        $0.backgroundColor = .default
    }
    private let addButton = UIButton().then {
        $0.setImage(UIImage(named: "addButton"), for: .normal)
    }
    private var tabs = {
        var viewControllers: [UIViewController] = []
        for viewController in TodoMainTab.allCases {
            viewControllers.append(viewController.configured)
        }
        return viewControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        makeUI()
        bind()
    }
    
    private func makeUI() {
        selectedIndex = 0
        tabBar.isHidden = true
        calendarButton.isSelected = true
        setViewControllers(tabs, animated: true)
        
        view.addSubview(titleLabel)
        view.addSubview(tabBarView)
        view.addSubview(addButton)

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(30)
        }
        tabBarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(46)
        }
        addButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-128)
            $0.size.equalTo(48)
        }
    }
    
    private func bind() {
        addButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.pushViewController(GoalsCreateViewController(), animated: true)
            }
            .store(in: &bag)
    }
    
    @objc
    func seletedView(_ sender: UIButton) {
        selectedIndex = sender.tag
        goalButton.isSelected = sender.tag == goalButton.tag
        mindsetButton.isSelected = sender.tag == mindsetButton.tag
        calendarButton.isSelected = sender.tag == calendarButton.tag
    }
}

extension TodoMainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
