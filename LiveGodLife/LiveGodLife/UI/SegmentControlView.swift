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

    private var selectedIndex: Int = 0 {
        didSet {
            buttons.forEach { $0.isSelected = false }
            buttons[selectedIndex].isSelected = true
            delegate?.didTapItem(index: selectedIndex)
        }
    }
    private var buttons: [SegmentControlButton] = []

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    init(frame: CGRect, items: [SegmentItem]) {
        super.init(frame: frame)

        items.enumerated().forEach { index, item in
            let button = SegmentControlButton()
            button.setTitle(item.title, for: .normal)
            button.setTitleColor(.gray2, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.tag = index
            button.addTarget(self, action: #selector(didTapItem), for: .touchUpInside)
            if index == 0 { button.isSelected = true }
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        stackView.frame = bounds
        addSubview(stackView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapItem(_ sender: UIButton) {
        guard sender.tag != selectedIndex else {
            return
        }
        selectedIndex = sender.tag
    }
}
