//
//  GoalCreateViewController.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/12/16.
//

import Foundation
import UIKit

class GoalCreateViewController: UIViewController {
    let inputGoal = UITextField()
    let textView = UIView()
    lazy var mindSetView: UIView = {
        let view = UIView()
        let title = UILabel()
        let addButton = UIButton()
      
        let leftImageView = UIImageView()
        let rightImageView = UIImageView()
        let mindSetTextLabel = UILabel()
        
        
        mindSetTextLabel.textColor = .white
        mindSetTextLabel.numberOfLines = 0
        mindSetTextLabel.text = "사는건 레벨업이 아닌 스펙트럼을 넓히는거란 얘길 들었다. 어떤 말보다 용기가 된다."
        leftImageView.image = UIImage(named: "leftQuote")
        rightImageView.image = UIImage(named: "rightQuote")
        
//        view.makeBorderGradation(startColor: .green, endColor: .blue, radius: 20)
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        
        self.textView.addSubview(leftImageView)
        self.textView.addSubview(mindSetTextLabel)
        self.textView.addSubview(rightImageView)
        
        view.addSubview(self.textView)
        
        leftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(13)
            make.height.equalTo(13)
        }
        mindSetTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalTo(leftImageView.snp.right).offset(15)
            make.right.equalTo(rightImageView.snp.left).offset(15)
            make.bottom.equalToSuperview().offset(-24)
        }
        rightImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.right.equalToSuperview().offset(-26)
            make.width.equalTo(13)
            make.height.equalTo(13)
        }
        self.textView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.bottom.right.equalToSuperview().offset(-16)
            
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        let inputGoalsImage = UIImageView()
        let spaceView = UIView()
        spaceView.backgroundColor = .darkGray
        self.view.addSubview(spaceView)
        self.view.addSubview(mindSetView)
        
        spaceView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(36)
            make.left.right.equalTo(self.view)
            make.height.equalTo(16)
        }
        
        mindSetView.snp.makeConstraints { make in
            make.top.equalTo(spaceView).offset(32)
            make.left.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
            
        }


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.backButtonTitle = "목표추가"
    }
}

class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let gradient = UIImage()
        let gradientColor = UIColor(patternImage: gradient
            .gradientImage(
                bounds: self.bounds,
                colors: [
                    .green,
                    .blue
                ]
            )
        )
        self.layer.borderColor = gradientColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
