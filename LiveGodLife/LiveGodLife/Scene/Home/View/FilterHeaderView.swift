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
        $0.font = .bold(with: 20)
        $0.textColor = .white
        $0.text = "갓생 엿보기"
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .background
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
        }
        addSubview(categoryFilterView)
        categoryFilterView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
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
