//
//  GoalOfTodoCell.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/12/26.
//

import Foundation
import UIKit

enum TodoSetting: CaseIterable {
    case period
    case repetition
    case alarm
    
    var type: String {
        switch self {
        case .period:
            return "기간"
        case .repetition:
            return "반복"
        case .alarm:
            return "알람"
        }
    }
    
    var defaultText: String {
        switch self {
        case .period:
            return "기간 설정(필수)"
        case .repetition:
            return "반복 설정(선택)"
        case .alarm:
            return "당일 오전 9시"
        }
    }
    
    var imageView:UIImageView {
        let imageView = UIImageView()
        var image = UIImage()
        switch self {
        case .period:
            image = UIImage(named: "period") ?? UIImage()
            imageView.image = image
            return imageView
        case .repetition:
            image = UIImage(named: "repetition") ?? UIImage()
            imageView.image = image
            return imageView

        case .alarm:
            image = UIImage(named: "alarm") ?? UIImage()
            imageView.image = image
            return imageView
        }
    }
}

class GoalOfTodoCell: CommonCell {
    // MARK: - Variable
    var dataModel:ChildTodo? {
        didSet {
            update()
        }
    }
    let checkImage = UIImageView()
    let titleTextField = UITextField()

    let periodLabel = UILabel()
    let repetitionLabel = UILabel()
    let alarmLabel = UILabel()
    
    let periodButton = UIButton()
    let repetitionButton = UIButton()
    let alarmButton = UIButton()
    
    lazy var labels = [
        self.periodLabel,
        self.repetitionLabel,
        self.alarmLabel,
    ]
    
    lazy var button = [
        self.periodButton,
        self.repetitionButton,
        self.alarmButton,
    ]
    
    lazy var contentsView:UIView = {
        let view = UIView()
        let settingStackView = UIStackView()
        settingStackView.spacing = 32
        settingStackView.axis = .vertical
        view.addSubview(settingStackView)
       
        var index = 0
        TodoSetting.allCases.forEach {(item) in
            var settingView: UIView {
                let view = UIView()
                let typeLabel = UILabel()
                let imageView = item.imageView
                
//                labels[index].text = ite
                typeLabel.text = item.type
                typeLabel.textColor = .BBBBBB
                labels[index].text = item.defaultText
                labels[index].textColor = .BBBBBB
                button[index].tag = index
                button[index].setImage(UIImage(named: "todoDetail"), for: .normal)
                
                view.addSubview(imageView)
                view.addSubview(typeLabel)
                view.addSubview(labels[index])
                view.addSubview(button[index])
                
                imageView.snp.makeConstraints { make in
                    make.top.equalTo(view)
                    make.left.equalTo(view).offset(44)
                    make.width.equalTo(16)
                    make.height.equalTo(16)
                }
                typeLabel.snp.makeConstraints { make in
                    make.top.equalTo(imageView)
                    make.left.equalTo(imageView.snp.right).offset(7)
                }
                labels[index].snp.makeConstraints { make in
                    make.top.equalTo(imageView)
                    make.right.equalTo(button[index].snp.left).offset(-4)
                }
                button[index].snp.makeConstraints { make in
                    make.top.equalTo(view)
                    make.right.equalTo(view).offset(-16)
                    make.width.equalTo(24)
                    make.height.equalTo(24)
                }
                index = index + 1
                return view
            }
            settingStackView.addArrangedSubview(settingView)
        }
        
        settingStackView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-10)
            make.height.equalTo(62)
        }
        
       
        return view
    }()
   


    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Func
    override func setUpModel() {
        super.setUpModel()
    }
    
    func addViews(){
        
        checkImage.image = UIImage(named: "checked")
        titleTextField.attributedPlaceholder = "컨셉잡기".title16White
        titleTextField.font = .title16
        titleTextField.textColor = .white
        

        self.addSubview(self.checkImage)
        self.addSubview(self.titleTextField)
        self.addSubview(self.contentsView)
    
    }
    
    func update() {
        if dataModel?.type == "FOLDER" {
            checkImage.snp.makeConstraints { make in
                make.top.equalTo(self).offset(28)
                make.left.equalTo(self).offset(16)
                make.width.equalTo(24)
                make.height.equalTo(24)
            }
            titleTextField.snp.makeConstraints { make in
                make.top.equalTo(self).offset(24)
                make.left.equalTo(checkImage.snp.right).offset(16)
                make.height.equalTo(24)
            }
            self.contentsView.snp.makeConstraints { make in
                make.top.equalTo(self.titleTextField.snp.bottom).offset(24)
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.height.equalTo(96)
            }
            self.setNeedsDisplay()
        } else {
            self.contentsView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.height.equalTo(96)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
            }
        }
        
//        if dataModel?.type == "CAREER" {
//            self.contentsView.snp.makeConstraints { make in
//                make.top.equalTo(titleTextField.snp.bottom).offset(16)
//                make.top.equalToSuperview().offset(5)
//                make.bottom.equalToSuperview().offset(-5)
//                make.left.equalToSuperview()
//                make.right.equalToSuperview()
//            }
//        } else {
//            self.contentsView.snp.makeConstraints { make in
//                make.top.equalToSuperview()
//                make.bottom.equalToSuperview()
//                make.left.equalToSuperview()
//                make.right.equalToSuperview()
//            }
//        }
        
    }
    
    @objc func change(_ sender: UIButton) {
        labels[sender.tag].text = "test"
    }
}
