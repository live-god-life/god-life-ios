//
//  HomeFeedCollectionViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/28.
//

import UIKit
import SnapKit

final class FeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!

    static let identifier = "FeedCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 30
        bookmarkButton.setImage(UIImage(named: "bookmark_disable"), for: .normal)
        bookmarkButton.setImage(UIImage(named: "bookmark"), for: .selected)
    }

    func configure(with data: Feed) {
        userNameLabel.text = data.user.nickname
        titleLabel.text = data.title
        bookmarkButton.isSelected = data.isBookmark
    }

    @IBAction func didTapBookmarkButton(_ sendser: UIButton) {
        bookmarkButton.isSelected = !bookmarkButton.isSelected
    }
}
