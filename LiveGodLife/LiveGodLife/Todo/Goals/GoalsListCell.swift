//
//  GoalsListCell.swift
//  LiveGodLife
//
//  Created by khAhn on 2022/11/30.
//

import Foundation
import UIKit

class GoalsListCell: CommonCell {
    
    var dataModel:GoalsModel? {
        didSet {
            update()
        }
    }
    
    let datelabel = UILabel()
    let mindsetImage = UIImageView()
    let mindsetCountLabel = UILabel()
    let totalTodoCountLabel = UILabel()
    let totalTodoImage = UIImageView()
    let completedTodoCount = UILabel()
    let completedTodoImage = UIImageView()
    let dDayLabel = UILabel()
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    func addViews(){
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        
        self.backgroundColor = .blue
    }

    func update() {
        titleLabel.text = dataModel?.title ?? ""
    }
    
    override func setUpModel() {
        super.setUpModel()
    }
}
