//
//  MindsetListCell.swift
//  LiveGodLife
//
//  Created by Quintet on 2022/11/23.
//

import Foundation
import UIKit

class MindsetListCell: CommonCell {
    // MARK: - Variable
    var dataModel:SubMindSetModel? {
        didSet {
            update()
        }
    }
    
    let contentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
//        label.font = font
        return label
    }()
    let checkButton = UIButton()

    lazy var contentsView:UIView = {
        let view = UIView()
        let leftImageView = UIImageView()
        let rightImageView = UIImageView()
        
        self.contentsLabel.textColor = .white
        
        leftImageView.image = UIImage(named: "leftQuote")
        rightImageView.image = UIImage(named: "rightQuote")
        
        view.layer.cornerRadius = 20

        view.addSubview(leftImageView)
        view.addSubview(self.contentsLabel)
        view.addSubview(rightImageView)
        
        leftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(13)
            make.height.equalTo(13)
        }
        self.contentsLabel.snp.makeConstraints { make in
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

        return view
    }()
   


    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        let gradient = UIImage.gradientImage(bounds: self.bounds, colors: [.green , .blue])
        let gradientColor = UIColor(patternImage: gradient)
        self.layer.borderColor = gradientColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20

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
//        typeLabel.text = dataModel?.taskType
        contentsLabel.text = "\(dataModel?.content ?? "")"
//        typeLabel.textColor = dataModel?.taskType == "Todo" ? .green : .blue
    }
}
