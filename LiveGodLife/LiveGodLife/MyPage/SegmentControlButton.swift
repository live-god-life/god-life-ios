//
//  SegmentControlButton.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/06.
//

import UIKit
import SnapKit

final class SegmentControlButton: UIButton {

    let highlightView = UIView()

    override var isSelected: Bool {
        didSet {
            let selected = UIFont(name: "Pretendard-Bold", size: 16)
            let normal = UIFont(name: "Pretendard", size: 16)
            titleLabel?.font = isSelected ? selected : normal
            highlightView.backgroundColor = isSelected ? .green : .clear
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel?.font = .regular(with: 16)

        addSubview(highlightView)
        highlightView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
