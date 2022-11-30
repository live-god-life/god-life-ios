//
//  FilterHeaderView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/30.
//

import UIKit
import SnapKit

class FilterHeaderView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(with: 20)
        label.textColor = .white
        label.text = "갓생 엿보기"
        return label
    }()
    let categoryFilterView = CategoryFilterView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black
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

    func configure(items: [Category]) {
        categoryFilterView.configure(items: items)
    }
}
