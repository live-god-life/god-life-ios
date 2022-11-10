//
//  TodoCollectionViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/09.
//

import UIKit

final class TodoCollectionViewCell: UICollectionViewCell {

    static let identifier = "TodoCollectionViewCell"

    @IBOutlet weak var checkButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 51
        checkButton.tintColor = .green
        checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .selected)
    }
}
