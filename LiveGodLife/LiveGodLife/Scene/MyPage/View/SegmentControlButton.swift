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
    let lineView = UIView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.2)
    }
    let highlightView = UIView()
    var highlightViewColor: UIColor = .green

    override var isSelected: Bool {
        didSet {
            let selected = UIFont.semiBold(with: 18)
            let normal = UIFont.semiBold(with: 18)
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

        addSubview(lineView)
        addSubview(highlightView)
        
        lineView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        highlightView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(94)
            $0.height.equalTo(2)
        }
    }
}
