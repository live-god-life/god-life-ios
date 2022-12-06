//
//  TodoMainTabViewController.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/28.
//

import Foundation
import UIKit

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
    var commonButton:UIButton {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return button
    }
    
    let calendarButton = UIButton()
    let mindsetButton = UIButton()
    let goalButton = UIButton()
    
    lazy var tabBarView: UIStackView =  {
        let stack = UIStackView()
        
        self.calendarButton.setTitleColor(UIColor.black, for: .normal)
        self.calendarButton.setTitle("캘린더", for: .normal)
        self.calendarButton.tag = 0
        self.calendarButton.addTarget(self, action: #selector(seletedView(_:)), for: .touchUpInside)
        self.mindsetButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.mindsetButton.setTitle("마인드셋", for: .normal)
        self.mindsetButton.tag = 1
        self.mindsetButton.addTarget(self, action: #selector(seletedView(_:)), for: .touchUpInside)
        self.goalButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.goalButton.setTitle("목표", for: .normal)
        self.goalButton.tag = 2
        self.goalButton.addTarget(self, action: #selector(seletedView(_:)), for: .touchUpInside)

        
        self.calendarButton.setBackgroundColor(.green, for: .normal)
        self.calendarButton.setBackgroundColor(.green, for: .selected)

        self.mindsetButton.setBackgroundColor(.clear, for: .normal)
        self.mindsetButton.setBackgroundColor(.green, for: .selected)
        self.mindsetButton.setBackgroundColor(.darkGray, for: .disabled)
        
        self.goalButton.setBackgroundColor(.clear, for: .normal)
        self.goalButton.setBackgroundColor(.green, for: .selected)
        self.goalButton.setBackgroundColor(.darkGray, for: .disabled)
        
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = 5
        
        
        stack.addArrangedSubview(self.calendarButton)
        stack.addArrangedSubview(self.mindsetButton)
        stack.addArrangedSubview(self.goalButton)
        
        stack.layer.masksToBounds = true
        stack.layer.cornerRadius = 30
        stack.layer.borderWidth = 1
        stack.layer.borderColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
//        stack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
       
        for v in stack.arrangedSubviews {
            v.layer.cornerRadius = 20
            v.clipsToBounds = true
        }
        return stack
    }()
    
    var tabs: [UIViewController]? = {
        var viewControllers: [UIViewController] = []
        for viewController in TodoMainTab.allCases {
            viewControllers.append(viewController.configured)
        }
        return viewControllers
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TodoMainViewLoad")
        setViewControllers(tabs, animated: true)
        self.delegate = self
        tabBar.isHidden = true

        view.addSubview(self.tabBarView)
        self.tabBarView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.left.equalTo(self.view).offset(10)
            $0.right.equalTo(self.view).offset(-10)
            $0.height.equalTo(60)
        }

    }
    //comment 여러번 초기화 되는 함수
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func seletedView(_ sender: UIButton) {
        selectedIndex = sender.tag
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
