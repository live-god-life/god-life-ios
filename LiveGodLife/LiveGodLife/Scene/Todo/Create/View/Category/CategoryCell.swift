//
//  CategoryCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/02/02.
//

import Then
import SnapKit
import UIKit
//MARK: CategoryCell
final class CategoryCell: UICollectionViewCell {
    //MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.textColor = .gray3
        $0.textAlignment = .center
        $0.font = .bold(with: 14)
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .green : .black
            contentView.layer.borderColor = isSelected ? nil : UIColor.gray3.cgColor
            contentView.layer.borderWidth = isSelected ? .zero : 1.0
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentView.backgroundColor = .black
        titleLabel.textColor = .gray3
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.backgroundColor = .black
        contentView.layer.borderColor = UIColor.gray3.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 10.0
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(category: String?, isSelected: Bool) {
        titleLabel.text = category
        
        contentView.backgroundColor = isSelected ? .green : .black
        contentView.layer.borderColor = isSelected ? nil : UIColor.gray3.cgColor
        contentView.layer.borderWidth = isSelected ? .zero : 1.0
        
        titleLabel.textColor = isSelected ? .black : .gray3
    }
    
    static func width(text: String) -> CGFloat {
        return UILabel.textSize(font: .bold(with: 14)!, text: text, height: 30.0).width + 24.0
    }
}

