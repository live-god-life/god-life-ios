//
//  CalendarListCell.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/15.
//

import Foundation
import UIKit

class CalendarListCell: CommonCell {
    // MARK: - Variable
    var dataModel:SubGoals? {
        didSet {
            update()
        }
    }
    let typeLabel = UILabel()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = font
        return label
    }()
    let checkButton = UIButton()

    lazy var contentsView:UIView = {
        let view = UIView()
        self.titleLabel.textColor = .white
        self.typeLabel.textColor = .green

        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 1
        view.addSubview(self.typeLabel)
        view.addSubview(self.titleLabel)
        view.addSubview(self.checkButton)
        
        self.typeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-24)
        }
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalTo(self.typeLabel.snp.right).offset(15)
            make.bottom.equalToSuperview().offset(-24)
        }
        self.checkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-26)
            make.bottom.equalToSuperview().offset(-24)
        }
        return view
    }()
   


    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Func
    override func setUpModel() {
        super.setUpModel()
//        dataModel = (super.model as? MainGoals ?? MainGoals(title: "", goalId: 1, rawValue: "", todoSchedules: [])).todoSchedules
    }
    
    func addViews(){
        self.addSubview(self.contentsView)
        self.backgroundColor = .black
        self.contentsView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func update() {
        typeLabel.text = dataModel?.taskType
        titleLabel.text = "• \(dataModel?.title ?? "")"

    }
}
