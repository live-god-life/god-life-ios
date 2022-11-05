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

    class CustomButton: UIButton {

        override var isSelected: Bool {
            didSet {
                let selected = UIFont(name: "Pretendard-Bold", size: 16)
                let normal = UIFont(name: "Pretendard", size: 16)
                titleLabel?.font = isSelected ? selected : normal
            }
        }
    }

    weak var delegate: SegmentControlViewDelegate?

//    private let items: [SegmentItem]
    private var selectedIndex: Int = 0
    private var buttons: [CustomButton] = []

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    init(frame: CGRect, items: [SegmentItem]) {
        // TODO: 스크롤 효과
//        self.items = items
        super.init(frame: frame)

        items.enumerated().forEach { index, item in
            let button = CustomButton()
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
        buttons[selectedIndex].isSelected = false
        sender.isSelected = true
        selectedIndex = sender.tag
        delegate?.didTapItem(index: sender.tag)
    }
}
