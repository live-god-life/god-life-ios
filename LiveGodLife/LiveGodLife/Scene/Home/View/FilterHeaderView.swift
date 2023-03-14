//
//  FilterHeaderView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/30.
//

import UIKit
import SnapKit

final class FilterHeaderView: UIView {
    //MARK: - Properties
    let categoryFilterView = CategoryFilterView()
    private let titleLabel = UILabel().then {
        $0.font = .semiBold(with: 24)
        $0.textColor = .white
        $0.text = "갓생 발견하기"
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black
        
        addSubview(titleLabel)
        addSubview(categoryFilterView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        categoryFilterView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(36)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Functions...
    func configure(items: [Category]) {
        categoryFilterView.configure(items: items)
    }
}
