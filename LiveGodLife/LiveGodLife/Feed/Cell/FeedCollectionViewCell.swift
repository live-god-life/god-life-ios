//
//  FeedCollectionViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/28.
//

import UIKit
import SnapKit
import Kingfisher

final class FeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gradationView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var todoCountLabel: UILabel!
    @IBOutlet weak var todoScheduleDay: UILabel!
    @IBOutlet weak var feedInfoView: UIView!

    static let identifier = "FeedCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 30
        bookmarkButton.setImage(UIImage(named: "bookmark_disable"), for: .normal)
        bookmarkButton.setImage(UIImage(named: "bookmark"), for: .selected)
        feedInfoView.layer.borderWidth = 1
        feedInfoView.layer.borderColor = UIColor.green.cgColor
        feedInfoView.layer.cornerRadius = feedInfoView.frame.height / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .default
    }

    func configure(with feed: Feed) {
        imageView.kf.setImage(with: URL(string: feed.image))
        userNameLabel.text = feed.user.nickname
        titleLabel.text = feed.title
        bookmarkButton.isSelected = feed.isBookmark
        todoCountLabel.text = "\(feed.todoCount) List"
        todoScheduleDay.text = "\(feed.todoScheduleDay) Day"
        let color = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1)
        gradationView.backgroundColor = color
    }

    @IBAction func didTapBookmarkButton(_ sendser: UIButton) {
        bookmarkButton.isSelected = !bookmarkButton.isSelected
    }
}
