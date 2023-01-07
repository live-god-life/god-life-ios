//
//  DefaultCollectionViewCell.swift
//  LiveGodLife
//
//  Created by wargi on 2023/01/26.
//

import Then
import SnapKit
import UIKit
//MARK: DefaultCollectionViewCell
final class DefaultCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    
    
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
        
    }
}
