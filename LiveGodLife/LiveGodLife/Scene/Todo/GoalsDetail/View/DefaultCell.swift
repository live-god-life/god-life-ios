//
//  DefaultCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/26.
//

import Then
import SnapKit
import UIKit
//MARK: DefaultCell
final class DefaultCell: UICollectionViewCell {
    //MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .montserrat(with: 18, weight: .semibold)
        $0.isHidden = true
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.isHidden = true
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.bottom.right.equalToSuperview()
            $0.height.equalTo(28)
        }
    }
    
    func configure(with title: String?) {
        contentView.backgroundColor = .black
        
        titleLabel.text = title
        titleLabel.isHidden = false
    }
}
