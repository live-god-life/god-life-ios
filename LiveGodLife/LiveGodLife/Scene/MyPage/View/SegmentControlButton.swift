//
//  SegmentControlButton.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/06.
//

import UIKit
import SnapKit

final class SegmentControlButton: UIButton {
    //MARK: - Properties
    let highlightView = UIView()
    var highlightViewColor: UIColor = .green

    override var isSelected: Bool {
        didSet {
            let selected = UIFont.bold(with: 16)
            let normal = UIFont.regular(with: 16)
            titleLabel?.font = isSelected ? selected : normal
            highlightView.backgroundColor = isSelected ? highlightViewColor : .clear
        }
    }

    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions...
    private func makeUI() {
        titleLabel?.font = .regular(with: 16)

        addSubview(highlightView)
        highlightView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
