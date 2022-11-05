//
//  SegmentControlView.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/30.
//

import UIKit
import SnapKit

struct SegmentItem {

    let title: String
}

protocol SegmentControlViewDelegate: AnyObject {

    func didTapItem(index: Int)
}

class SegmentControlView: UIView {

    weak var delegate: SegmentControlViewDelegate?

    private let items: [SegmentItem]

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    init(frame: CGRect, items: [SegmentItem]) {
        // TODO: 스크롤 효과
        self.items = items
        super.init(frame: frame)

        items.enumerated().forEach { index, item in
            let button = UIButton()
            button.setTitle(item.title, for: .normal)
            button.tintColor = .white
            button.tag = index
            button.addTarget(self, action: #selector(didTapItem), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        stackView.frame = bounds
        addSubview(stackView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapItem(_ sender: UIButton) {
        delegate?.didTapItem(index: sender.tag)
    }
}
