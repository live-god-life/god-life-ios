//
//  HomeFeedCollectionViewCell.swift
//  LiveGodLife
//
//  Created by Ador on 2022/10/28.
//

import UIKit
import SnapKit

final class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var todoCountLabel: UILabel!
    @IBOutlet weak var todoScheduleDay: UILabel!
    @IBOutlet weak var feedInfoView: UIView!

    static let identifier = "FeedTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .background
        bookmarkButton.setImage(UIImage(named: "bookmark_disable"), for: .normal)
        bookmarkButton.setImage(UIImage(named: "bookmark"), for: .selected)
        feedInfoView.layer.borderWidth = 1
        feedInfoView.layer.borderColor = UIColor.green.cgColor
        feedInfoView.layer.cornerRadius = feedInfoView.frame.height / 2
        feedImageView.backgroundColor = .default
        feedImageView.layer.cornerRadius = 30
    }

    func configure(with feed: Feed) {
        userNameLabel.text = feed.user.nickname
        titleLabel.text = feed.title
        bookmarkButton.isSelected = feed.isBookmark
        todoCountLabel.text = "\(feed.todoCount) List"
        todoScheduleDay.text = "\(feed.todoScheduleDay) Day"
    }

    @IBAction func didTapBookmarkButton(_ sendser: UIButton) {
        bookmarkButton.isSelected = !bookmarkButton.isSelected
    }
}
