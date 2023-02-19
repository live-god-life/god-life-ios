//
//  TodoMainTabBarController.swift
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
    
    var vc: UIViewController {
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
        let vc = self.vc
        vc.title = self.title
        vc.hidesBottomBarWhenPushed = false
        vc.tabBarItem = self.tabBarItem
        return vc
    }
}

protocol TodoTabBarViewDelegate: AnyObject {
    func setVC(with index: Int)
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
        $0.titleLabel?.font = .regular(with: 16)
        $0.setTitleColor(.gray8, for: .normal)
        $0.setTitleColor(.black, for: .selected)
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setBackgroundColor(.green, for: .selected)
        $0.addTarget(self, action: #selector(seletedView(_:)), for: .touchUpInside)
    }
    private lazy var mindsetButton = UIButton().then {
        $0.tag = 1
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 17
        $0.setTitle("마인드셋", for: .normal)
        $0.titleLabel?.font = .regular(with: 16)
        $0.setTitleColor(.gray8, for: .normal)
        $0.setTitleColor(.black, for: .selected)
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setBackgroundColor(.green, for: .selected)
        $0.addTarget(self, action: #selector(seletedView(_:)), for: .touchUpInside)
    }
    private lazy var goalButton = UIButton().then {
        $0.tag = 2
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 17
        $0.setTitle("목표", for: .normal)
        $0.titleLabel?.font = .regular(with: 16)
        $0.setTitleColor(.gray8, for: .normal)
        $0.setTitleColor(.black, for: .selected)
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setBackgroundColor(.green, for: .selected)
        $0.addTarget(self, action: #selector(seletedView(_:)), for: .touchUpInside)
    }
    private let titleLabel = UILabel().then {
        $0.text = "TODO"
        $0.textColor = .white
        $0.font = .montserrat(with: 18, weight: .semibold)
    }
    private lazy var tabBarView = UIStackView().then {
        $0.spacing = .zero
        $0.alignment = .fill
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        $0.isLayoutMarginsRelativeArrangement = true
        
        $0.addArrangedSubview(self.calendarButton)
        $0.addArrangedSubview(self.mindsetButton)
        $0.addArrangedSubview(self.goalButton)
        
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
        $0.backgroundColor = .gray7
    }
    private let addButton = UIButton().then {
        $0.setImage(UIImage(named: "addButton"), for: .normal)
    }
    private var tabs = {
        var viewControllers: [UIViewController] = []
        for vc in TodoMainTab.allCases {
            viewControllers.append(vc.configured)
        }
        return viewControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        makeUI()
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
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(44)
        }
        tabBarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        addButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-129)
            $0.size.equalTo(48)
        }
    }
    
    private func bind() {
        delegate = self
        
        addButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                let newModel = CreateGoalsModel(title: "", categoryCode: "LIFESTYLE", mindsets: [], todos: [])
                self?.navigationController?.pushViewController(GoalsCreateVC(model: newModel),
                                                               animated: true)
            }
            .store(in: &bag)
    }
    
    @objc
    func seletedView(_ sender: UIButton) {
        selectedIndex = sender.tag
        goalButton.isSelected = sender.tag == goalButton.tag
        mindsetButton.isSelected = sender.tag == mindsetButton.tag
        calendarButton.isSelected = sender.tag == calendarButton.tag
        
        goalButton.titleLabel?.font = sender.tag == goalButton.tag ? .semiBold(with: 16) : .regular(with: 16)
        mindsetButton.titleLabel?.font = sender.tag == mindsetButton.tag ? .semiBold(with: 16) : .regular(with: 16)
        calendarButton.titleLabel?.font = sender.tag == calendarButton.tag ? .semiBold(with: 16) : .regular(with: 16)
    }
}

extension TodoMainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
