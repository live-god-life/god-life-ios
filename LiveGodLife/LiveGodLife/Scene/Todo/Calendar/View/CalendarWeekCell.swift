//
//  CalendarWeekCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/28.
//

import Then
import SnapKit
import UIKit
//MARK: CalendarWeekCell
final class CalendarWeekCell: UICollectionViewCell {
    //MARK: - Properties
    let weekLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .montserrat(with: 14, weight: .bold)
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.addSubview(weekLabel)
        
        weekLabel.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func configure(with text: String?) {
        weekLabel.text = text
    }
}
