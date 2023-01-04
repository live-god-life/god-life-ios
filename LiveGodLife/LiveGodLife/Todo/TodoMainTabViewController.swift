//
//  TodoMainTabViewController.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/28.
//

import UIKit
import SnapKit
import Then

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
            return CalendarListViewController()
        case .mindset:
            return MindsetListViewController()
        case .goal:
            return GoalsListViewController()
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

class TodoMainTabBarController: UITabBarController {
    var commonButton = UIButton().then {
        $0.backgroundColor = .black
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 50
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    let calendarButton = UIButton()
    let mindsetButton = UIButton()
    let goalButton = UIButton()
    let titleLabel = UILabel().then {
        $0.text = "TODO"
        $0.textColor = .white
        $0.font = .montserrat(with: 20, weight: .bold)
    }
    
    lazy var tabBarView = UIStackView().then {
        self.calendarButton.tag = 0
        self.calendarButton.clipsToBounds = true
        self.calendarButton.layer.cornerRadius = 17
        self.calendarButton.setTitle("캘린더", for: .normal)
        self.calendarButton.titleLabel?.font = .bold(with: 14)
        self.calendarButton.setBackgroundColor(.clear, for: .normal)
        self.calendarButton.setTitleColor(UIColor(sharpString: "999999")!, for: .normal)
        self.calendarButton.setTitleColor(UIColor(sharpString: "#111111")!, for: .selected)
        self.calendarButton.setBackgroundColor(UIColor(sharpString: "7CFC00")!, for: .selected)
        self.calendarButton.addTarget(self, action: #selector(seletedView(_:)), for: .touchUpInside)

        self.mindsetButton.tag = 1
        self.mindsetButton.clipsToBounds = true
        self.mindsetButton.layer.cornerRadius = 17
        self.mindsetButton.setTitle("마인드셋", for: .normal)
        self.mindsetButton.titleLabel?.font = .bold(with: 14)
        self.mindsetButton.setBackgroundColor(.clear, for: .normal)
        self.mindsetButton.setTitleColor(UIColor(sharpString: "999999")!, for: .normal)
        self.mindsetButton.setTitleColor(UIColor(sharpString: "#111111")!, for: .selected)
        self.mindsetButton.setBackgroundColor(UIColor(sharpString: "7CFC00")!, for: .selected)
        self.mindsetButton.addTarget(self, action: #selector(seletedView(_:)), for: .touchUpInside)
        
        self.goalButton.tag = 2
        self.goalButton.clipsToBounds = true
        self.goalButton.layer.cornerRadius = 17
        self.goalButton.setTitle("목표", for: .normal)
        self.goalButton.titleLabel?.font = .bold(with: 14)
        self.goalButton.setBackgroundColor(.clear, for: .normal)
        self.goalButton.setTitleColor(UIColor(sharpString: "999999")!, for: .normal)
        self.goalButton.setTitleColor(UIColor(sharpString: "#111111")!, for: .selected)
        self.goalButton.setBackgroundColor(UIColor(sharpString: "7CFC00")!, for: .selected)
        self.goalButton.addTarget(self, action: #selector(seletedView(_:)), for: .touchUpInside)
        
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
        $0.backgroundColor = UIColor(sharpString: "333333")
    }
    
    var tabs: [UIViewController]? = {
        var viewControllers: [UIViewController] = []
        for viewController in TodoMainTab.allCases {
            viewControllers.append(viewController.configured)
        }
        return viewControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIButton()
        setViewControllers(tabs, animated: true)
        
        self.delegate = self
        
        tabBar.isHidden = true

        view.addSubview(titleLabel)
        view.addSubview(tabBarView)
        view.addSubview(addButton)
        
        addButton.setImage(UIImage(named: "addButton"), for: .normal)
        addButton.addTarget(self, action: #selector(add(_:)), for: .touchUpInside)

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
        
        selectedIndex = 0
        calendarButton.isSelected = true
    }
    //comment 여러번 초기화 되는 함수
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func seletedView(_ sender: UIButton) {
        var isSelected = false
        [calendarButton, mindsetButton, goalButton].enumerated().forEach { (index, button) in
            if (index != selectedIndex) {
                isSelected = true
            } else {
                button.isSelected = index != selectedIndex
            }
       
        }
        sender.isSelected = isSelected
        selectedIndex = sender.tag
    }
    
    @objc func add(_ sender: UIButton) {
        self.navigationController?.pushViewController(GoalsCreateViewController(), animated: true)
    }
}

extension TodoMainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
